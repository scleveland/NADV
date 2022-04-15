# Nucleotide Amino acid Derived Visualization (NADV)

This application is designed to translate a nucleotide sequence in all reading frames and the reverse complement when the start codon is encountered. The results will be the Amino Acid sequence or sequences derived from the nucleotide sequence - the results are displayed with the Amino Acids aligned over the nucleotides and can be downloaded as a textfile. Paste Nucleotide sequence in to the text area for translation and display. 

The default number of nucleotides per line in the output is 60 but can be changed to meet output requirements.

This is a Ruby on Rails Application that is unfortunately rather old but has been containerized. So in order to run it you will need the Docker or compatible container runtime environment.

## Running the application

If you wish to run the current application from the latest existing image use:
```
docker run --name nadv_app -p 80:80 -e PORT=80 -e RAILS_ENV=production scleveland/nadv:latest
```
You can then point your browser at http://localhost and use the application

## Building the application

You can choose to build it yourself with:
```
docker build -t nadv .
```
You can then run the application using:
```
docker run --name nadv_app -p 80:80 -e PORT=80 -e RAILS_ENV=production nadv
```
You can then point your browser at http://localhots and use the application

