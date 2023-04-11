#unzip ~/Downloads/evac153_supplementary_data.zip -d suppl_material
#libreoffice --headless --convert-to csv suppl_material/Suppl.Tables.xlsx
less Suppl.Tables.csv | awk -F"," '{print $7}' > List_NCBI_ids.txt
#wget https://ftp.ncbi.nlm.nih.gov/genomes/genbank/assembly_summary_genbank.txt
grep -w -Ff List_NCBI_ids.txt assembly_summary_genbank.txt > NCBI_GbkPATH_List.txt
#grep -w -Ff List_ids.txt assembly_summary_genbank.txt > NCBI_GbkPATH_List.txt
less NCBI_GbkPATH_List.txt  | awk -F" " '{print $21}' > NCBI_links.txt
#wget -nH --cut-dirs=6 --recursive --no-parent -i  echo less NCBI_links.txt + '/*'

for i in $(cat NCBI_links.txt)
do
   wget "${i}/${i:57}_genomic.gbff.gz"
done
