(ns jv.repl
  (:require
   [clj-async-profiler.core :as prof]
   [clj-reload.core :as reload]
   [clojure.math :as math]
   [clojure.repl.deps :as repl.deps]
   [criterium.core :as criterium]
   [io.julienvincent.bench.burner :as bench.burner]
   [io.julienvincent.dev.config :as dev.config]
   [io.julienvincent.dev.cp :as dev.cp]
   [io.julienvincent.dev.malli :as dev.malli]
   [io.julienvincent.dev.pprint :as dev.pprint]
   [io.julienvincent.dev.tap :as dev.tap]
   [nrepl.server :as nrepl])
  (:import
   [java.io FileDescriptor FileOutputStream]))

(dev.tap/add-stdout-tap)

(dev.malli/setup-malli-instrumentation (:instrumentation (dev.config/get-local-config)))
(try
  (reload/init {:dirs (dev.cp/collect-classpath)
                :no-reload '#{user}})
  nil
  (catch Exception ex
    (tap> "Failed to initialize clj-reload")
    (tap> ex)))

#_{:clojure-lsp/ignore [:clojure-lsp/unused-public-var]}
(defn list-bindings [binding-name]
  (if-let [sym (dev.config/get-binding binding-name)]
    (if (vector? sym)
      sym
      [sym])
    []))

(def ^:dynamic b* nil)

#_{:clojure-lsp/ignore [:clojure-lsp/unused-public-var]}
(defn run-binding!
  ([binding-name] (run-binding! binding-name nil))
  ([binding-name binding-sym]
   (if-let [sym (if (symbol? binding-sym)
                  binding-sym
                  (dev.config/get-binding binding-name))]
     (let [sym (if (vector? sym)
                 (first sym)
                 sym)]
       (if-let [f (requiring-resolve sym)]
         (let [_ (println (str "Running " sym))
               result (f)]
           (alter-var-root #'b* (constantly result)))

         (println (str "No " binding-name " var found"))))
     (println (str "No " binding-name " defined in project :local/config")))
   nil))

#_{:clojure-lsp/ignore [:clojure-lsp/unused-public-var]}
(defn reload-namespaces []
  (reload/reload)
  (dev.malli/setup-malli-instrumentation (:instrumentation (dev.config/get-local-config))))

#_{:clojure-lsp/ignore [:clojure-lsp/unused-public-var]}
(defn sync-deps []
  (repl.deps/sync-deps))

#_{:clojure-lsp/ignore [:clojure-lsp/unused-public-var]}
(defn start-profiler []
  (prof/serve-ui 6678))

#_{:clojure-lsp/ignore [:clojure-lsp/unused-public-var]}
(defmacro with-time [name & body]
  `(let [start# (System/nanoTime)
         result# (do ~@body)
         end# (System/nanoTime)
         delta# (-> (- end# start#)
                    (/ 10000.0)
                    math/round
                    (/ 100.0))]
     (prn (str "Time [" ~name "]: " delta# "ms"))
     (tap> [~name, delta#])
     result#))

#_{:clojure-lsp/ignore [:clojure-lsp/unused-public-var]}
(defn tap>> [& args]
  (tap> args)
  (last args))

(defn echo-repl [msg]
  (dev.pprint/echo *out* msg)
  msg)

(def ^:dynamic *stdout*
  (FileOutputStream. FileDescriptor/out))

(def ^:dynamic *stderr*
  (FileOutputStream. FileDescriptor/err))

(defn echo-stdout [msg]
  (dev.pprint/echo *stdout* msg)
  msg)

(defn echo-stderr [msg]
  (dev.pprint/echo *stderr* msg)
  msg)

#_{:clojure-lsp/ignore [:clojure-lsp/unused-public-var]}
(defmacro qbench [& body]
  `(criterium/with-progress-reporting (criterium/quick-bench (do ~@body) :verbose)))

#_{:clojure-lsp/ignore [:clojure-lsp/unused-public-var]}
(defmacro bench [& body]
  `(criterium/with-progress-reporting (criterium/bench (do ~@body) :verbose)))

#_{:clojure-lsp/ignore [:clojure-lsp/unused-public-var]}
(defmacro profile [& body]
  `(prof/profile ~@body))

(defn start-mcp-nrepl []
  (nrepl/start-server :port 7888))

(defmacro burn
  "This is a re-export. See the docstring for [io.julienvincent.bench.burner/burn]"
  {:style/indent :defn}
  [opts & body]
  `(bench.burner/burn ~opts ~@body))

nil
