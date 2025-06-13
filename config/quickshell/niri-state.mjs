import { spawn } from "node:child_process";

function parseStructArray(type, text) {
  const regex = new RegExp(`${type} \\{([^}]+)\\}`, "g");
  const items = [];
  let match;
  while ((match = regex.exec(text)) !== null) {
    const fields = {};
    match[1].split(",").forEach((pair) => {
      const [key, rawValue] = pair.split(":").map((v) => v.trim());
      if (!key) return;
      let val = rawValue;
      if (/^Some\(".*?"\)$/.test(val)) {
        val = val.match(/^Some\("(.*?)"\)$/)[1];
      } else if (val === "None") {
        val = null;
      } else if (val === "true") {
        val = true;
      } else if (val === "false") {
        val = false;
      } else if (/^\d+$/.test(val)) {
        val = Number(val);
      } else if (/^Some\((\d+)\)$/.test(val)) {
        val = Number(val.match(/^Some\((\d+)\)$/)[1]);
      }
      fields[key] = val;
    });
    items.push(fields);
  }
  return items;
}

let buffer = "";
let workspaces = [];
let windows = [];

function updateModel() {
  const outputMap = {};
  const wsIdToRef = {};

  for (const ws of workspaces) {
    if (!ws.output) continue;
    const output = ws.output;
    const idx = String(ws.idx);
    if (!outputMap[output]) outputMap[output] = {};
    outputMap[output][idx] = {
      name: ws.name ?? null,
      active: ws.is_active,
      focused: ws.is_focused,
      windows: [],
    };
    wsIdToRef[ws.id] = outputMap[output][idx];
  }

  for (const win of windows) {
    const targetWs = wsIdToRef[win.workspace_id];
    if (targetWs) {
      targetWs.windows.push({
        id: win.id,
        title: win.title ?? null,
        app_id: win.app_id ?? null,
        floating: win.is_floating,
        pid: win.pid,
        focused: win.is_focused,
      });
      if (win.is_focused) targetWs.focused = true;
    }
  }

  console.log(JSON.stringify(outputMap, null, 2));
  process.exit(0);
}

export function update() {
  const child = spawn("niri", ["msg", "event-stream"]);
  child.stdout.setEncoding("utf8");

  child.stdout.on("data", (data) => {
    buffer += data;
    const lines = buffer.split("\n");
    buffer = lines.pop();

    for (const line of lines) {
      if (line.includes("Workspaces changed:")) {
        workspaces = parseStructArray("Workspace", line);
      }
      if (line.includes("Windows changed:")) {
        windows = parseStructArray("Window", line);
      }
      if (workspaces.length && windows.length) {
        updateModel();
      }
    }
  });

  child.stderr.on("data", (err) => {
    console.error("stderr:", err.toString());
  });

  child.on("close", (code) => {
    console.log(`child process exited with code ${code}`);
  });
}

update();
