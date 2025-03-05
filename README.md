# Project Description
<!--{-->

- The purpose of this project is to create an algorithm/model that is able to take datasets generated from similar studies and combine them.
- The goal in combining the data from the different data sets in such a way as to reduce the noise that comes from each being a different data set but retain the biological signal present in the data.
- Similar problems have been tackled by many others, but this specific problem has not been approached before as we hope to.
- We want to create an algorithm that is as generalizable as possible.
- The data used for this process can be found on OSF at this [link](https://osf.io/eky3p/)
    - This data was collected and cleaned by Ifeanyichukwu Nwosu, a former PhD student of Dr. Piccolo

<!--}-->

# Repository Description
<!--{-->

- This repository holds all of the information about the work that I am doing as part of the Piccolo Lab in the Life Sciences Department of Brigham Young University
- This repository contains several folders, as outlined below, though it does not contain all of the folders that I have in my working directory as I work on this project.

<!--}-->

# Working Directory Contents
<!--{-->

- These are the folders that I have in my working directory:
    - data/
        - This folder holds the raw gene expression data obtained from <b>OSF</b>
    - [functions/](./functions/Contents.md)
        - This folder holds a set of functions that I have written to help in several tasks.
    - merged/
        - This folder holds all of the data sets after the metadata and gene expression data has been merged by the `collectMerged()` function
    - meta/
        - This folder holds all of the metadata for the different data sets obtained from <b>OSF</b>
    - models/
        - This folder holds all of the fit keras models that I use in my analysis, so I don't have to recreate them when I need to use them again.
    - [others/](./others/Contents.md)
        - This folder holds the other random things I use in generating documents and testing things in my project.
    - [plots/](./plots/Contents.md)
        - This folder holds all of the plots I have generated during my analysis for various reasons
    - pdfs/
        - This folder contains pdf versions of my updates
    - [scripts/](./scripts/Contents.md)
        - This folder holds all of the scripts that I use to run my analysis
    - [updates/](./updates/Contents.md)
        - These are `Markdown` files in which I keep track of the work I am doing, be it taking notes on ideas or the workflow/process of what I am accomplishing.
    - [variables/](./variables)
        - This folder holds any variables that are particularly important in my analysis that I don't want to have to obtain again when I need them.
- Some of these folders are not present in this repository because they only contain data, which I do not want to take up room in the repository since it is already stored in [OSF](https://osf.io/eky3p/)
- Furthermore, my models are too large to store on GitHub, so they are not found here.
- Hopefully that helps in explaining what everything is for and in finding anything of interest

<!--}-->

# Other Files
<!--{-->

- A list of my completed and yet unfinished tasks is found in my [TODO](./TODO.md) file

<!--}-->


