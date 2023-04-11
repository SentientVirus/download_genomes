#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec  8 15:27:32 2022

@author: marina
"""

import os

extension = snakemake.params.ext #['genomic.gbff', 'genomic.gff', 'genomic.fna', 'protein.faa']

infile = snakemake.input[0] #'NCBI_links.txt'

MP2 = snakemake.params.MP2

print(MP2)

def download_files(link_str):
    path = link_str.strip('\n')
    filename = path.split('/')[-1]
    print(filename)
    to_download = f'{path}/{filename}_{extension}.gz'
    strain = f'{filename.split("_")[2]}'
    print(strain)
    if 'ASM131494v1' in strain:
        strain = 'MP2'
    suffix = f'{strain}_{extension}'
    outdir = 'cds'
    if not os.path.exists(outdir):
        os.mkdir(outdir)
    print(f'{outdir}/{suffix}')
    os.system(f'wget {to_download} && mv {filename}_{extension}.gz {outdir}/{suffix}.gz && gunzip {outdir}/{suffix}.gz')

with open(infile) as links:
    for line in links:
        download_files(line)
download_files(MP2)
        # path = line.strip('\n')
        # filename = path.split('/')[-1]
        # for extension in extensions:
        #     to_download = f'{path}/{filename}_{extension}.gz'
        #     strain = f'{filename.split("_")[2]}'
        #     if 'MP2' in strain:
        #         strain = 'MP2'
        #     suffix = f'{strain}_{extension}'
        #     outdir = extension.split('.')[1]
        #     if not os.path.exists(outdir):
        #         os.mkdir(outdir)
        #     print(f'{outdir}/{suffix}')
        #     os.system(f'wget {to_download} && mv {filename}_{extension}.gz {outdir}/{suffix}.gz && gunzip {outdir}/{suffix}.gz')
