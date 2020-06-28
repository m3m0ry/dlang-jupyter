# dlang-jupyter
**Experimental** project for combining [drepl](https://github.com/dlang-community/drepl) and [jupyter_wire](https://github.com/symmetryinvestments/jupyter-wire).
There is some functionality and many issues.

## Building dlang-jupyter
- Clone the repository.
- Install `libzmq3-dev` to satisfy this dependency of `jupyter-wire`
- Build: `dub build`.
 
## Use kernel
In order to use the kernel, you need `jupyter` installed. Then you need to make this kernel available. Notice that this reposiry already has the `kernel.json` file.

Possible setup:
- Install [conda](https://docs.anaconda.com/anaconda/install/)
- (if necessary, export conda's path to be accesible with your shell. Conda has solutions for `bash`, `zsh`, `fish` and maybe other as well.)
- Create new environment: `conda env -n dlang-jupyter`
- Change to this environment: `conda activate dlang-jupyter`
- Install jupyter: `conda install jupyter`
- Set a link to this repository: `ln -s {REPOSITORY-PATH} {CONDA-PATH}/envs/dlang-jupyter/share/jupyter/kernels/dlang-jupyter`
- Run jupyter: `jupyter notebook`
- Create a new notebook, with `dlang-jupyter` as your kernel.
