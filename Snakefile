configfile: "config.yml"

rule all:
    input:
        "List_NCBI_ids.txt",
        "assembly_summary_genbank.txt",
        "NCBI_links.txt"
rule get_id_list:
    output:
        "List_NCBI_ids.txt"
    input:
        "/home/marina/Downloads/evac153_supplementary_data.zip"
        #Supplementary table S1, available here: https://academic.oup.com/gbe/article/14/11/evac153/6764223#380169858
    shadow: "minimal"
    shell:
        """
        unzip {input} -d suppl_material &&
        libreoffice --headless --convert-to csv suppl_material/Suppl.Tables.xlsx &&
        less Suppl.Tables.csv | awk -F',' '{{print $7}}' > {output}
        """

rule get_assembly_list:
    output:
        "assembly_summary_genbank.txt"
    shell:
        "wget https://ftp.ncbi.nlm.nih.gov/genomes/genbank/{output}"

rule get_links:
    output:
        "NCBI_links.txt"
    input:
        assembly_list = "assembly_summary_genbank.txt",
        ids = "List_NCBI_ids.txt"
    shell:        
        "grep -w -Ff {input.ids} {input.assembly_list} | awk -F' ' '{{print $21}}' > {output}"


rule download_files:
    output:
        expand("{ext}/{strains}_genomic.{ext}", ext = ["gbff", "gff", "fna"], strains = config["strains"]),
        expand("faa/{strains}_protein.faa", strains = config["strains"])
    input:
        "NCBI_links.txt"
#    shadow: "minimal"
    params:
        ext = config["extensions"],
        MP2 = "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/001/314/945/GCF_001314945.1_ASM131494v1"
    script:
        "download_files.py"

rule download_CDS_files:
    output:
        expand("cds/{strains}_cds_from_genomic.fna", strains = config["strains"])
    input:
        "NCBI_links.txt"
    params:
        ext = "cds_from_genomic.fna",
        MP2 = "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/001/314/945/GCF_001314945.1_ASM131494v1"
    script:
        "download_CDS.py"

rule download_extra_strains:
    output:
        expand("{ext}/{strains}_genomic.{ext}", ext = ["gbff", "gff", "fna"], strains = ["DSMZ12361", "IBH001"]),
        expand("faa/{strains}_protein.faa", strains = ["DSMZ12361", "IBH001"]),
        expand("cds/{strains}_cds_from_genomic.fna", strains = ["DSMZ12361", "IBH001"])
    params:
        ext = config["extensions"] + ["cds_from_genomic.fna"],
        ref = "https://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Apilactobacillus_kunkeei/latest_assembly_versions/GCF_019575995.1_ASM1957599v1",
        #"https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/019/575/995/GCF_019575995.1_ASM1957599v1",
        IBH001 = "https://ftp.ncbi.nlm.nih.gov/genomes/refseq/bacteria/Apilactobacillus_kunkeei/latest_assembly_versions/GCF_001281265.1_ASM128126v1"
    script:
        "download_extra.py"
