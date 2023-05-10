(setq user-full-name "Dmitry Egoov")

(setq doom-theme 'doom-one)

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(setq display-line-numbers-type 'relative)

(setq doom-font (font-spec :family "Iosevka" :size 13))

(after! cider
  (setq cider-repl-pop-to-buffer-on-connect nil))

(defun try-convert (out)
  (shell-command-on-region
   (region-beginning) (region-end)
   (format "~/convert.clj %s " out)
   nil "REPLACE" nil t))

(defun convert-to-edn  () (interactive) (try-convert "edn"))
(defun convert-to-json () (interactive) (try-convert "json"))
(defun convert-to-yaml () (interactive) (try-convert "yaml"))

(map! (:leader
       (:map (clojure-mode-map clojurescript-mode-map emacs-lisp-mode-map)
             (:prefix ("o")
                      "e" #'convert-to-edn
                      "j" #'convert-to-json
                      "y" #'convert-to-yaml))))

(map! (:leader
       (:map (clojure-mode-map clojurescript-mode-map emacs-lisp-mode-map)
        (:prefix ("k" . "lisp")
         "j" #'paredit-join-sexps
         "c" #'paredit-split-sexp
         "D" #'paredit-kill
         "d" #'sp-kill-sexp
         "<" #'paredit-backward-slurp-sexp
         ">" #'paredit-backward-barf-sexp
         "s" #'paredit-forward-slurp-sexp
         "b" #'paredit-forward-barf-sexp
         "r" #'paredit-raise-sexp
         "R" #'sp-rewrap-sexp
         "w" #'paredit-wrap-sexp
         "[" #'paredit-wrap-square
         "'" #'paredit-meta-doublequote
         "{" #'paredit-wrap-curly
         "y" #'sp-copy-sexp))))

(map! :leader
      (:prefix-map ("p" . "project")
       :desc "implementation <-> test"      "a" #'projectile-toggle-between-implementation-and-test))

(after! cider
  (set-popup-rules!
   '(("^\\*cider-repl"
      :side right
      :width 100
      :quit nil
      :ttl nil))))

(defun clj-insert-persist-scope-macro ()
  (interactive)
  (insert
   "(defmacro persist-scope
              \"Takes local scope vars and defines them in the global scope. Useful for RDD\"
              []
              `(do ~@(map (fn [v] `(def ~v ~v))
                  (keys (cond-> &env (contains? &env :locals) :locals)))))"))

(defun persist-scope ()
  (interactive)
  (let ((beg (point)))
    (clj-insert-persist-scope-macro)
    (cider-eval-region beg (point))
    (delete-region beg (point))
    (insert "(persist-scope)")
    (cider-eval-defun-at-point)
    (delete-region beg (point))))

;; (defun on-file-save ()
;;   (when (string-suffix-p ".js" (buffer-name))
;;     (let* ((default-directory (projectile-project-root))
;;            (output-buffer (get-buffer-create "*BB TCR Output*")))
;;       (async-shell-command "bb tcr" output-buffer output-buffer)
;;       (normal-mode))))

;; (add-hook 'after-save-hook 'on-file-save)
