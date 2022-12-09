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
        MP2 = "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/741/865/GCF_000741865.1_LkMP2v1.0"
    script:
        "download_files.py"
