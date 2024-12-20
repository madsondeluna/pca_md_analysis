#!/bin/bash

# Parte 1: Processamento com GROMACS
# Passo 1: Análise de covariância
gmx covar -f md_0_1noPBC.trr -s md_0_1.tpr <<EOF
4
4
EOF

# Passo 2: Análise do primeiro vetor principal
gmx anaeig -v eigenvec.trr -f md_0_1noPBC.trr -eig eigenval.xvg -s md_0_1.tpr -first 1 -last 1 -nframes 100 -extr ev1.pdb <<EOF
4
4
EOF

# Passo 3: Análise do segundo vetor principal
gmx anaeig -v eigenvec.trr -f md_0_1noPBC.trr -eig eigenval.xvg -s md_0_1.tpr -first 1 -last 2 -nframes 100 -extr ev2.pdb <<EOF
4
4
EOF

# Passo 4: Projeção no plano dos dois primeiros componentes principais
gmx anaeig -v eigenvec.trr -f md_0_1noPBC.trr -eig eigenval.xvg -s md_0_1.tpr -first 1 -last 2 -2d 2dproj_ev_1_2.xvg <<EOF
4
4
EOF

# Parte 2: Visualização com Python

python3 <<EOF
import matplotlib.pyplot as plt

# Função para carregar o arquivo .xvg
def load_xvg(filename):
    x, y = [], []
    with open(filename, 'r') as file:
        for line in file:
            if line.startswith(('#', '@')):  # Ignorar comentários e cabeçalhos
                continue
            parts = line.split()
            x.append(float(parts[0]))
            y.append(float(parts[1]))
    return x, y

# Carregar os dados de PCA
x, y = load_xvg('2dproj_ev_1_2.xvg')

# Plotar o gráfico
plt.figure(figsize=(8, 6))
plt.scatter(x, y, c='blue', alpha=0.7, edgecolor='k', label='Projeção PCA')
plt.title('Projeção PCA da Trajetória Molecular', fontsize=14)
plt.xlabel('Componente Principal 1', fontsize=12)
plt.ylabel('Componente Principal 2', fontsize=12)
plt.legend()
plt.grid(True)
plt.savefig('pca_plot.png')  # Salvar a figura
plt.show()
EOF
