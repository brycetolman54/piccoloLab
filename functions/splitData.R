splitData = function(dataSet, test, val, seed, splitClass = TRUE) {
    set.seed(seed)
    
    split = initial_split(dataSet, prop = 1 - test)
    train = training(split)
    test = testing(split)
    
    split = initial_split(train, prop = 1 - val)
    train = training(split)
    val = testing(split)
    
    if(!splitClass) {
        return(list("train" = train,
                    "val" = val,
                    "test" = test))
    }
    
    trainClasses = train |> select(Class) |> mutate(Class = as.factor(Class))
    train = train |> select(-Class)
    
    valClasses = val |> select(Class) |> mutate(Class = as.factor(Class))
    val = val |> select(-Class)
    
    testClasses = test |> select(Class) |> mutate(Class = as.factor(Class))
    test = test |> select (-Class)
    
    return(list("train" = train,
                "trainClasses" = trainClasses,
                "val" = val,
                "valClasses" = valClasses,
                "test" = test,
                "testClasses" = testClasses))

}