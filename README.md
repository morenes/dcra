
Artifact Evaluation for the paper [DCRA: A Distributed Chiplet-based Reconfigurable Architecture for Irregular Applications](https://arxiv.org/abs/2311.15443)


# Generate Figures

## Figure 4 - NoC

    python3 plots/characterization.py -p 19 -m 0
    python3 plots/characterization.py -p 19 -m 7
    python3 plots/characterization.py -p 19 -m 10


## Figure 5 - SRAM

    python3 plots/characterization.py -p 9 -m 0
    python3 plots/characterization.py -p 9 -m 7
    python3 plots/characterization.py -p 9 -m 10
    python3 plots/characterization.py -p 9 -m 9 #hitrate


## Figure 6 - Granularity, PU/Tile

    python3 plots/characterization.py -p 23 -m 0
    python3 plots/characterization.py -p 23 -m 7


## Figure 7 - PU Frequency

    python3 plots/characterization.py -p 20 -m 0
    python3 plots/characterization.py -p 20 -m 7


## Figure 8 - Integrating HBM

    python3 plots/characterization.py -p 2
    python3 plots/characterization.py -p 3


## Figure 9 - Energy Breakdown

    python3 plots/characterization.py -p 1 -m 0
    python3 plots/characterization.py -p 1 -m 1


## Figure 10 - Scaling Plot

    python3 plots/characterization.py -p 4 -m 0
    python3 plots/characterization.py -p 4 -m 1




# Runs


## Figure 4 - NoC

    exp_dcra/run_exp_noc_bw.sh 9 0 4 64


## Figure 5 - SRAM

    exp_dcra/run_exp_mem.sh 9 0 6 Kron25
    exp_dcra/run_exp_mem.sh 9 0 6 Kron22


## Figure 6 - Granularity, PU/Tile

    exp_dcra/run_exp_granularity.sh 9 0 2 64


## Figure 7 - PU Frequency

    exp_dcra/run_exp_pufreq.sh 9 0 4 64


## Figures 8 and 9

    exp_dcra/run_exp_packages.sh 9 0 3 Kron25
    exp_dcra/run_exp_packages.sh 9 0 3 Kron26


## Figure 10 - Scaling Plot

    exp_dcra/run_exp_scaling_dcra.sh 9 1 3 Kron25
    exp_dcra/run_exp_scaling_dcra.sh 9 1 3 Kron26
