(lambda say-hello [person]
  (print (.. "hello, " person))
  )

(say-hello "world")
