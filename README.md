# Willow's RPG documents

A collection of documents relating to my RPG campaigns

Powered by LaTeX, using the [5e LaTeX template](https://github.com/ashonit/DND-5e-LaTeX-Template).

## Usage

To build a particular document, run `make document-name`. For the printable version, run `make document-name-printable`. For both, run `make document-name-all`.

To build all documents in both printable and normal, run `make all`.

To add a new document:

 1. Under `docs`, create a folder with the directory name being the project name
 2. In the new folder, create `main.tex`
 3. In the `Makefile`, add the project/directory name to `DOCS`

## Documents

### player-guide

A guide to introduce new players to the ins and outs of playing an RPG with me as the GM.
