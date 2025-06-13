import { execSync } from "child_process";
const workspaceInput = execSync("niri msg workspaces").toString();
// const windowInput = execSync("niri msg windows").toString();

const parseWorkspaces = (input) => {
  const lines = input.trim().split("\n");
  const result = {};
  let currentOutput = null;

  for (const line of lines) {
    const outputMatch = line.match(/^Output\s+"([^"]+)":$/);
    const workspaceMatch = line.match(/^[\s*]*([0-9]+)\s+"([^"]+)"$/);
    const unnamedMatch = line.match(/^[\s*]*([0-9]+)\s*$/);

    if (outputMatch) {
      currentOutput = outputMatch[1];
      result[currentOutput] = {};
    } else if (workspaceMatch && currentOutput) {
      const index = workspaceMatch[1];
      const name = workspaceMatch[2];
      const isActive = /^\s*\*/.test(line);
      result[currentOutput][index] = {
        name,
        active: isActive,
        focused: false,
        // windows: [],
      };
    } else if (unnamedMatch && currentOutput) {
      const index = unnamedMatch[1];
      const isActive = /^\s*\*/.test(line);
      result[currentOutput][index] = {
        name: null,
        active: isActive,
        focused: false,
        // windows: [],
      };
    }
  }

  return result;
};

const parseWindows = (input) => {
  const windows = [];
  const entries = input.trim().split(/\n(?=Window ID \d+)/);

  for (const entry of entries) {
    const idMatch = entry.match(/^Window ID (\d+):(?: \(focused\))?/m);
    const focused = /\(focused\)/.test(entry);
    const titleMatch = entry.match(/Title:\s+"([^"]+)"/);
    const appIdMatch = entry.match(/App ID:\s+"([^"]+)"/);
    const floatMatch = entry.match(/Is floating:\s+(yes|no)/);
    const pidMatch = entry.match(/PID:\s+(\d+)/);
    const wsMatch = entry.match(/Workspace ID:\s+(\d+)/);

    if (idMatch && wsMatch) {
      windows.push({
        id: parseInt(idMatch[1]),
        title: titleMatch?.[1] ?? null,
        app_id: appIdMatch?.[1] ?? null,
        floating: floatMatch?.[1] === "yes",
        pid: parseInt(pidMatch?.[1] ?? 0),
        workspace_id: wsMatch[1],
        focused,
      });
    }
  }

  return windows;
};

const mergeData = (workspaces, windows) => {
  const indexMap = {};

  for (const output in workspaces) {
    for (const wsIndex in workspaces[output]) {
      indexMap[wsIndex] = workspaces[output][wsIndex];
    }
  }

  for (const win of windows) {
    const ws = indexMap[win.workspace_id];
    if (ws) {
      ws.windows.push({
        id: win.id,
        title: win.title,
        app_id: win.app_id,
        floating: win.floating,
        pid: win.pid,
        focused: win.focused,
      });
      if (win.focused) ws.focused = true;
    }
  }

  return workspaces;
};

// Run the full process
const workspaceData = parseWorkspaces(workspaceInput);
// const windowData = parseWindows(windowInput);
// const merged = mergeData(workspaceData, windowData);

// console.log(JSON.stringify(merged, null, 2));
console.log(JSON.stringify(workspaceData, null, 2));
