################################################################################
# cleans up the models to make sure they do not carry over between runs
################################################################################

suppressWarnings({
    rm(
        standardEncoder,
        standardDecoder,
        Encoder,
        Discriminator,
        Adversary
    )
})

invisible(gc())