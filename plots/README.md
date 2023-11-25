# Plotting Data

## Plot heatmaps
    NOTE: To be able to plot heatmaps, you need to have run the experiment with verbose>=2

    heatmap.py -m <mesh> -a <app> -d <dataset> -t <metric> -b <binary> -f <fixed_range>

    //Example plot the heapmap of the 8x8 simulation of Kron16 and binary A
    python3 plots/heatmap.py -m 8 -a sssp -d Kron16 -t cores -b A -f 1

## Characterization Experiments
    characterization.py -p <plot_type> -m <metric>
    
    Look inside the characterization.py to see the plot that you want to generate based on the experiments that you have run.

    //Example plot impact of Proxy sizes.
    python3 plots/characterization.py -p 12 -m 0