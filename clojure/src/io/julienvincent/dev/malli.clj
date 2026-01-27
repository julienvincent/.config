(ns io.julienvincent.dev.malli
  (:require
   [malli.dev :as dev]))

(defn- report-fn [report key data]
  (when (= :malli.core/register-function-schema key)
    (throw (ex-info (str "Failed to register function schema for "
                         (:ns data) "/" (:name data))
                    {:ns (:ns data)
                     :name (:name data)})))

  (when (:log report)
    (tap> {:type key
           :data data}))

  (when (:throw report)
    (case key
      :malli.core/invalid-schema
      (throw (ex-info "Invalid malli schema" data))

      :malli.core/invalid-entry
      (throw (ex-info "Invalid entry" data))

      (throw (ex-info (str "Function "
                           (:fn-name data)
                           " schema not satisfied - "
                           key)
                      (cond-> {:input (:args data)
                               :type key
                               :fn (:fn-name data)}
                        (:value data) (assoc :output (:value data))))))))

(defn setup-malli-instrumentation [config]
  (let [{:keys [enable report]
         :or {enable true
              report :throw}} config

        report (if (set? report)
                 report
                 #{report})]

    (when enable
      (try (dev/start! {:report (fn [key data]
                                  (report-fn report key data))})
           (catch Exception ex
             (tap> "Failed to initialize malli instrumentation")
             (tap> ex))))))
