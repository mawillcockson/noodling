(defn print-dots []
    (while true
        (prin ".")
        (flush)
        (ev/sleep 0.1)))

(def pd (ev/call print-dots))

(slurp "pegpeg.janet")

(ev/cancel pd :stop)
