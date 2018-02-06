
test.sys.on.exit <- function() {
  
  on.exit(print(1))
  ex <- sys.on.exit()
  str(ex)
  
  cat("exiting...\n")
}

test.sys.on.exit <- function() {
  
  for (i in 1:3) {
    on.exit(print(i), add = TRUE)
    ex <- sys.on.exit()
    str(ex)
  }
  cat("exiting...\n")
  
}

test.sys.on.exit <- function() {
  
  for (i in 1:3) {
    quoted <- substitute(on.exit(expr = print(x), add = TRUE), list(x = i))
    print(quoted)
    cur_env <- environment()
    eval(quoted, envir = cur_env)
    ex <- sys.on.exit()
    str(ex)
  }
  cat("exiting...\n")
}

test.sys.on.exit <- function() {
  eval(quote(on.exit(print(1))))
  ex <- sys.on.exit()
  str(ex)
  
  cat("exiting...\n")
  
}

test.sys.on.exit <- function() {
  evalq(on.exit(print(1)))
  ex <- sys.on.exit()
  str(ex)
  
  cat("exiting...\n")
  
}

test.sys.on.exit <- function() {
  
  for (i in 1:3) {
    do.call("on.exit",
            list(expr = substitute(print(x),
                                   list(x = i)),
                 add = TRUE))
    ex <- sys.on.exit()
    str(ex)
  }
  cat("exiting...\n")
  
}