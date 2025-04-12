This folder contains all the scripts necessary to produce the data contained in this package.

-   `00-metadata.R` downloads the names and URLs of all rulings in the 1992-2024 period. It also contains adds additional metadata such as `type`, `descriptors`, `year`, and `date`.

    *Note. The `mp`* *field is no longer included in the final dataset since the data collected in the* [cccLLM](https://github.com/acastroaraujo/cccllm) *package is better.*

-   `01-get-texts.R` downloads all text files from the URLs and stores them in a folder called `texts`.

-   `02-citations-and-counts.R` creates the `citations` dataset and adds additional fields to `metadata`, such as citations and word counts.

-   `03-pre-process.R` modifies the texts downloaded earlier in such a way that it makes it easier for the lemmatization procedure. It stores these new files in a folder called `txts`.

-   `04-lemmatization.py` this is the only Python script I used. It uses the [Stanza](https://stanfordnlp.github.io/stanza/) library which is better a Spanish lemmatization than the spaCy library.

    *Note. You need to set up an environment with the libraries in the `requirements.txt`*.

-   `05-docterms.R` creates the document-term matrix.
