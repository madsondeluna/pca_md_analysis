# PCA Analysis of Molecular Dynamics Trajectory

This project performs a Principal Component Analysis (PCA) on a molecular dynamics trajectory using GROMACS tools and visualizes the results with Python.

## Overview

The script automates the following steps:
1. Perform covariance analysis with GROMACS (`gmx covar`).
2. Analyze eigenvectors and extract projections using GROMACS (`gmx anaeig`).
3. Plot the PCA projection in Python using `matplotlib`.

## Requirements

### Software
- [GROMACS](http://www.gromacs.org/) (version 2020 or later recommended)
- Python 3.6 or later

### Python Libraries
- `matplotlib`

Install the required Python library with:
```bash
pip install matplotlib
```

## Files Used

### Input Files
- `md_0_1noPBC.trr`: Trajectory file without periodic boundary conditions.
- `md_0_1.tpr`: Run input file.

### Generated Files
- `eigenvec.trr`: Eigenvector file.
- `eigenval.xvg`: Eigenvalues.
- `2dproj_ev_1_2.xvg`: PCA projection on the first two principal components.
- `pca_plot.png`: Visualization of the PCA.

## Usage

1. Make the script executable:
    ```bash
    chmod a+x pca_analysis.sh
    ```

2. Run the script:
    ```bash
    ./pca_analysis.sh
    ```

3. The PCA plot will be generated and saved as `pca_plot.png`.

## Script Details

### Bash
The script runs the following GROMACS commands:
```bash
gmx covar -f md_0_1noPBC.trr -s md_0_1.tpr <<EOF
4
4
EOF

gmx anaeig -v eigenvec.trr -f md_0_1noPBC.trr -eig eigenval.xvg -s md_0_1.tpr -first 1 -last 1 -nframes 100 -extr ev1.pdb <<EOF
4
4
EOF

gmx anaeig -v eigenvec.trr -f md_0_1noPBC.trr -eig eigenval.xvg -s md_0_1.tpr -first 1 -last 2 -2d 2dproj_ev_1_2.xvg <<EOF
4
4
EOF
```

### Python
The Python script reads the PCA projection from `2dproj_ev_1_2.xvg` and plots it using `matplotlib`:
```python
import matplotlib.pyplot as plt

def load_xvg(filename):
    x, y = [], []
    with open(filename, 'r') as file:
        for line in file:
            if line.startswith(('#', '@')):  # Ignore comments and headers
                continue
            parts = line.split()
            x.append(float(parts[0]))
            y.append(float(parts[1]))
    return x, y

x, y = load_xvg('2dproj_ev_1_2.xvg')

plt.figure(figsize=(8, 6))
plt.scatter(x, y, c='blue', alpha=0.7, edgecolor='k', label='PCA Projection')
plt.title('PCA Projection of Molecular Dynamics Trajectory', fontsize=14)
plt.xlabel('Principal Component 1', fontsize=12)
plt.ylabel('Principal Component 2', fontsize=12)
plt.legend()
plt.grid(True)
plt.savefig('pca_plot.png')
plt.show()
```

## Output Example

The resulting PCA plot shows the projection of the molecular dynamics trajectory along the first two principal components. This visualization helps in identifying dominant motions in the system.

