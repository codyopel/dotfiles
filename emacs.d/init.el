; disable startup message
(setq inhibit-startup-message t)

; always follow symlinks
(setq vc-follow-symlinks nil)

(set-face-attribute 'default nil :height 90)

; ---------------------------
;     Syntax Highlighting
; ---------------------------
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme 'monokai t)

; ---------------------------
;        Line Numbers
; ---------------------------
(global-linum-mode 1)
; Pad space around numbers
(setq linum-format " %d ")

(column-number-mode 1)

; ---------------------------
;          Mini Map
; ---------------------------
(add-to-list 'load-path "~/.emacs.d/plugins/sublimity/")
(require 'sublimity)
(require 'sublimity-scroll)
(require 'sublimity-map)
(sublimity-mode 1)
