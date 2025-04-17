splitData = function(dataSet,
                     test = 0.3,
                     val = 0.3,
                     seed = -1,
                     splitClass = TRUE) {
  
    # Function to split data into tain, val, and test sets
    # 
    # Inputs:
    #   - dataSet (required): the actual data set (not a string) to be split
    #   - test (optional): the proportion of data to make the test set [default is 0.3]
    #   - val (optional): the proportion of the remaining data to make the val set [default is 0.3]
    #   - seed (optional): the seed with which to set the randomness, for reproducibility [default is -1, meaning no seed is set]
    #   - splitClass (optional): whether or not to split the Class data from the rest of the data and return it separately [default is TRUE]
    #
    # Outputs:
    #   - a list of the train, val, and test sets (as $train, $val, $test)
    #   - a list (continuing that above) of the classes for each set, if desired (as $trainClasses, $valClasses, $testClasses)
  
    if(seed > 0) set.seed(seed)
    
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