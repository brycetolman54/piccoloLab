mine = tibble(one = c(1,2,3,4,5), two = c(2,4,6,8,10), three = c(3,6,9,12,15))
yours = tibble(three = c(5,4,3,2,1), two = c(10,8,6,4,2), one = c(15,12,9,6,3))
ours = bind_rows(mine[1:3,], yours[3:5,])
sets = c("mine", "yours", "ours")
lts = mget(sets)
i = 1
for(set in lts) {
    suppressMessages(eval(expr(!!sym(sets[i]) <<- anti_join(set, ours))))
    i = i + 1
}
