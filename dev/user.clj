(ns user
  (:require [nextjournal.clerk :as clerk]))

(clerk/show! "README.md")

(future
  ;; NOTE: if we don't delay this, the message about starting the
  ;; `sci.nrepl` server will be printed first and thus cider will
  ;; connect to that port instead of the clojure one

  ;; (Thread/sleep 1000)
  ;; this is not needed when using
  ;; clerk-render-repl-cider-jack-in-clj&cljs (v1)

  (clerk/serve! {:browse true}))
