#!/usr/bin/env nextflow

// Include NfUtils
Class groovyClass = new GroovyClassLoader(getClass().getClassLoader()).parseClass(new File(params.classpath));
GroovyObject nfUtils = (GroovyObject) groovyClass.newInstance();

// Define internal params
module_name = 'samtools'

// Specify DSL2
nextflow.preview.dsl = 2

// Define default nextflow internals
params.internal_outdir = params.outdir
params.internal_process_name = 'samtools'

// samtools parameters
params.internal_custom_args = ''

// Check if globals need to 
nfUtils.check_internal_overrides(module_name, params)

// Trimming reusable component
process samtools {
    tag "${sample_id}"

    publishDir "${params.internal_outdir}/${params.internal_process_name}",
        mode: "copy", overwrite: true

    input:
      tuple val(sample_id), path(bam)

    output:
      tuple val(sample_id), path("*.bam.bai"), emit: baiFiles
 
    shell:
    
    // Set the main arguments
    samtools_args = ''
    samtools_args += "$params.internal_custom_args "
    
    """
    samtools index $samtools_args -@ ${task.cpus} $bam
    """
}
