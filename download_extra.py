#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec  8 15:27:32 2022

@author: marina
"""

import os

extensions = snakemake.params.ext #+ snakemake.params.CDS

ref = snakemake.params.ref
IBH = snakemake.params.IBH001

def download_files(link_str):
    path = link_str.strip('\n')
    filename = path.split('/')[-1]
    print(filename)
    for extension in extensions:
        to_download = f'{path}/{filename}_{extension}.gz'
        strain = f'{filename.split("_")[2]}'
        if 'ASM19' in strain:
            strain = 'DSMZ12361'
        else:
            strain = 'IBH001'
        suffix = f'{strain}_{extension}'
        outdir = extension.split('.')[1]
        if 'cds' in extension:
            outdir = 'cds'
        if not os.path.exists(outdir):
            os.mkdir(outdir)
        print(f'{outdir}/{suffix}')
        os.system(f'wget {to_download} && mv {filename}_{extension}.gz {outdir}/{suffix}.gz && gunzip {outdir}/{suffix}.gz')


download_files(ref)
download_files(IBH)
