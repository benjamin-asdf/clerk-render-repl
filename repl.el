;; connect with `nbb` type
(cider-connect-cljs '(:host "localhost" :port 1339 :cljs-repl-type nbb))


;; how to do this for type custom?
;; I would not use 'custom', users might have overriden the custom config already - Benjamin
(cider-connect-cljs '(:host "localhost" :port 1339 :cljs-repl-type custom :cider-repl-cljs-upgrade-pending nil))

;; Version 1, a bespoke jack-in-clj&cljs:

(defun clerk-render-repl-cider-jack-in-clj&cljs (&optional params)
  "A bespoke cider jack in for clerk-render-repl.
This waits for both nrepl servers to run and then jacks in a clj and a cljs nrepl."
  (interactive "P")
  (let* ((params (thread-first
                   params
                   (plist-put
                    :project-type 'clojure-cli)
                   (plist-put
                    :cljs-repl-type 'sci-browser-nrepl)))
         (cljs-endpoint '(:host "localhost" :port 1339))
         (params (cider--update-params params))
         (orig-buffer (current-buffer)))
    (nrepl-start-server-process
     (plist-get params :project-dir)
     (plist-get params :jack-in-cmd)
     (let ((clj-endpoint nil)
           (clj-endpoint-ready nil)
           (cljs-endpoint-ready nil))
       (lambda (server-buffer)
         (cond ((equal cljs-endpoint
                       nrepl-endpoint)
                (setf cljs-endpoint-ready t))
               (t
                (progn
                  (setf
                   clj-endpoint
                   nrepl-endpoint)
                  (setf clj-endpoint-ready t))))
         ;; ----------------------
         ;; signal that we are not done waiting,
         (setf nrepl-endpoint nil)
         ;; -----------------------
         (when (and cljs-endpoint-ready
                    clj-endpoint-ready)
           ;; ... until we are done waiting
           (setf nrepl-endpoint clj-endpoint)
           (with-current-buffer
               orig-buffer
             (let ((clj-repl (cider-connect-sibling-clj
                              params
                              server-buffer)))
               (cider-register-cljs-repl-type 'sci-browser-nrepl)
               (sit-for 1)
               (cider-connect-sibling-cljs
                (thread-first
                  params
                  (plist-put
                   :port (plist-get cljs-endpoint :port))
                  (plist-put
                   :host (plist-get cljs-endpoint :host)))
                clj-repl)))))))))

(let ((cider-clojure-cli-aliases ":dev"))
  (clerk-render-repl-cider-jack-in-clj&cljs))



;; I also need to setup an env for jvm
;; I do that with a run.sh script
;; - Benjamin

(let ((cider-clojure-cli-aliases ":dev")
      (cider-clojure-cli-command (expand-file-name "./run.sh")))
  (clerk-render-repl-cider-jack-in-clj&cljs))

