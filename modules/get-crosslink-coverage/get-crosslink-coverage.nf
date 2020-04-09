#!/usr/bin/env nextflow

// Specify DSL2
nextflow.preview.dsl = 2

// Local default params
params.outdir = './results'
params.getcrosslinkcoverage_processname = 'crosslinkcoverage'

process getcrosslinkcoverage {
    label 'mid_memory'
    publishDir "${params.outdir}/${params.getcrosslinkcoverage_processname}",
        mode: "copy", overwrite: true

    input:
      each path(bed)

    output:
      tuple path("${bed.simpleName}.bedgraph.gz"), path("${bed.simpleName}.norm.bedgraph.gz")
    //   path "${bed.baseName}.norm.bedgraph.gz"

    script:
    """
    # Raw bedgraphs
    gunzip -c $bed | awk '{OFS = "\t"}{if (\$6 == "+") {print \$1, \$2, \$3, \$5} else {print \$1, \$2, \$3, -\$5}}' | pigz > ${bed.simpleName}.bedgraph.gz
    
    # Normalised bedgraphs
    TOTAL=`gunzip -c $bed | awk 'BEGIN {total=0} {total=total+\$5} END {print total}'`
    echo \$TOTAL
    gunzip -c $bed | awk -v total=\$TOTAL '{printf "%s\\t%i\\t%i\\t%s\\t%f\\t%s\\n", \$1, \$2, \$3, \$4, 1000000*\$5/total, \$6}' | \
    awk '{OFS = "\t"}{if (\$6 == "+") {print \$1, \$2, \$3, \$5} else {print \$1, \$2, \$3, -\$5}}' | \
    sort -k1,1 -k2,2n | pigz > ${bed.simpleName}.norm.bedgraph.gz
    """
}