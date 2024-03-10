(in-ns 'user)

(require '[clj-reload.core :as reload])
(require '[malli.dev :as dev])
(require '[clojure.string :as str])
(require '[clojure.java.io :as io])
(require '[clojure.pprint :as pprint])
(require '[puget.printer :as puget])

(def m2-dir
  (str (System/getenv "HOME") "/.m2"))

(def classpath
  (into #{}
        (comp
         (filter (fn [path]
                   (not (str/starts-with? path m2-dir))))
         (filter (fn [path]
                   (let [file (io/file path)]
                     (and (.exists file)
                          (.isDirectory file)))))
         (filter (fn [path]
                   (not (some #{path} #{"dev" "local"}))))
         (map (fn [path]
                (->> (java.io.File. path)
                     .getAbsolutePath
                     str))))

        (str/split (System/getProperty "java.class.path") #":")))

(reload/init {:dirs classpath})

(add-tap
 (bound-fn*
  (fn [data]
    (binding [*out* (java.io.PrintWriter. (java.io.OutputStreamWriter. System/out))]
      (puget/pprint data {:print-color true
                          :color-scheme {:delimiter nil
                                         :tag       [:white]

                                         :nil       [:bold :black]
                                         :boolean   [:green]
                                         :number    [:magenta :bold]
                                         :string    [:bold :green]
                                         :character [:bold :magenta]
                                         :keyword   [:bold :red]
                                         :symbol    [:white :bold]

                                         :function-symbol [:bold :blue]
                                         :class-delimiter [:blue]
                                         :class-name      [:bold :blue]}})))))

(defn instrument! []
  #_(binding [*out* (java.io.PrintWriter. (java.io.OutputStreamWriter. System/out))]
      (dev/start!)))

(defn reload-namespaces []
  (reload/reload)
  (instrument!))

(instrument!)
