(macro tag-mask [n]
  ;; River uses a bitmask to represent tags (1:1, 2:2, 3:4, 4:8, etc.).
  ;; Use this macro when interacting with tags.
  ;; We need to import "bit", since luajit doesn't have lshift built-in.
  `(let [bit# (require :bit)]
     (tostring (bit#.lshift 1 (- ,n 1)))))

(fn rc [& args]
  "Run a riverctl command."
  (table.insert args 1 :riverctl)
  (os.execute (table.concat args " ")))

(macro nmap [mods key action ...]
  `(rc :map :normal ,mods ,key ,action ,...))

;; core binds
(nmap :Super :T :spawn :wezterm)
(nmap :Super :B :spawn :zen-beta)
(nmap :Super :D :spawn :fuzzel)
(nmap :Super :Q :close)
(nmap :Super+Shift :E :exit)
(nmap :Super+Shift :F :toggle-fullscreen)
;; NOTE: this doesn't currently clear keybinds
(nmap :Super+Shift :R :spawn "~/.config/river/init")

(nmap :Super :H :focus-view :left)
(nmap :Super :J :focus-view :down)
(nmap :Super :K :focus-view :up)
(nmap :Super :L :focus-view :right)

(nmap :Super+Shift :H :swap :left)
(nmap :Super+Shift :J :swap :down)
(nmap :Super+Shift :K :swap :up)
(nmap :Super+Shift :L :swap :right)

;; tags
(for [i 1 9]
  (let [tags (tag-mask i)]
    (rc :map :normal :Super (tostring i) :set-focused-tags tags)
    (rc :map :normal :Super+Shift (tostring i) :set-view-tags tags)))

(fn assign-tag [app-id tag-num]
  (rc :rule-add :-app-id app-id :tags (tag-mask tag-num)))

;; Assign programs to tags
(assign-tag :zen-beta 2)

;; layout
(rc :default-layout :rivertile)
(rc :attach-mode :bottom)

;; autostart
; (execute "rivertile -view-padding 2 -outer-padding 2 &")
; (execute "waybar &")
;; kill existing instances before (re)spawning
(os.execute "pkill waybar; waybar &")
(os.execute "pkill rivertile; rivertile -view-padding 2 -outer-padding 2 &")
