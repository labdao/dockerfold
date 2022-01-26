# lab-alphafold
a dockerized alphafold v2 implementation based on collabfold

## AWS
AMI ID: ami-00339339e800db52e

## directory structure

```
├── LICENSE
├── Makefile           <- Makefile with commands like `make data` or `make train`
├── README.md          <- The top-level README for developers using this project.
├── data
│   ├── external       <- Data from third party sources
│   ├── interim        <- Intermediate data that has been transformed
│   ├── processed      <- Output information, to be sent back to the client
│   └── raw            <- Input information, to be processed
│
├── collabfold         <- Trained models, including MOFA models and UMAP clustering results
│
│
├── references         <- Data dictionaries, manuals, and all other explanatory materials such as supplementary tables.
│
├── reports            <- Generated graphics and figures to be used in QC reporting
│
├── requirements.txt   <- The requirements file for reproducing the analysis environment, e.g.
│                         generated with `pip freeze > requirements.txt`
│
├── src                <- Source code for use in this project next to collabfold.
│   │
│   ├── data           <- Scripts for IO, for example to download, generate and pre-process data
│   │
│   ├── models         <- Scripts to extract features, train models, create UMAP embeddings and run MOFA        
│   │
│   └── visualization  <- Scripts to create exploratory visualizations (only works with raw data access)
│
└── docker            <- dockerfiles
```

