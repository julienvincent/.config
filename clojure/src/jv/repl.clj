(ns jv.repl
  (:require
   [clj-async-profiler.core :as prof]
   [clj-reload.core :as reload]
   [clojure.math :as math]
   [clojure.repl.deps :as repl.deps]
   [criterium.core :as criterium]
   [io.julienvincent.dev.config :as dev.config]
   [io.julienvincent.dev.cp :as dev.cp]
   [io.julienvincent.dev.malli :as dev.malli]
   [io.julienvincent.dev.tap :as dev.tap]))

(dev.tap/add-stdout-tap)

(dev.malli/setup-malli-instrumentation (:instrumentation (dev.config/get-local-config)))
(try
  (reload/init {:dirs (dev.cp/collect-classpath)})
  nil
  (catch Exception ex
    (tap> "Failed to initialize clj-reload")
    (tap> ex)))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(defn list-bindings [binding-name]
  (if-let [sym (dev.config/get-binding binding-name)]
    (if (vector? sym)
      sym
      [sym])
    []))

(defonce ^:private binding-value*
  (atom {}))

(defn b* [name]
  (get @binding-value* name))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
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
         (do (println (str "Running " sym))
             (swap! binding-value* assoc binding-name (f)))
         (println (str "No " binding-name " var found"))))
     (println (str "No " binding-name " defined in project :local/config")))
   nil))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(defn reload-namespaces []
  (reload/reload)
  (dev.malli/setup-malli-instrumentation (:instrumentation (dev.config/get-local-config))))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(defn sync-deps []
  (repl.deps/sync-deps))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(defn start-profiler []
  (prof/serve-ui 6678))

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
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

#_{:clj-kondo/ignore [:clojure-lsp/unused-public-var]}
(defn tap>> [& args]
  (doseq [arg args]
    (tap> arg))

  (last args))

(defmacro qbench [& body]
  `(criterium/with-progress-reporting (criterium/quick-bench (do ~@body) :verbose)))

(defmacro bench [& body]
  `(criterium/with-progress-reporting (criterium/bench (do ~@body) :verbose)))

(defmacro profile [& body]
  `(prof/profile ~@body))

nil
