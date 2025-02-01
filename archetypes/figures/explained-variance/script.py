import scanpy as sc
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from archetypes import AA
from archetypes.datasets import sort_by_archetype_similarity, permute_dataset

adata_skeletal = sc.read_h5ad('~/WJ.Skeletal.h5ad')
adata_skeletal.X = adata_skeletal.X.astype(np.float64)

pca_embedding = adata_skeletal.obsm['X_pca']
X = pd.DataFrame(pca_embedding, index=adata_skeletal.obs.index)

del pca_embedding

def run(df, k=3):

  method_kwargs = {
      "max_iter_optimizer": 10,
  }

  model = AA(n_archetypes=k, method="pgd", method_kwargs=method_kwargs, random_state=3)
  model.fit(df)

  X_sorted, info = sort_by_archetype_similarity(df, [model.similarity_degree_], model.archetypes_)
  similarity_degree_permuted, _ = permute_dataset(model.similarity_degree_, info["perms"])
  flattened_perms = np.concatenate(info["perms"])

  return (similarity_degree_permuted, flattened_perms, X_sorted, model)
  
k_values = []
rss_values = []

with open('~/rss_values1.txt', 'w') as f:
  for j in range(0, 10):
      print(j)
      subsampled_X = X.sample(frac=0.8)
      print(subsampled_X.shape)
      for k in range(1, 31):
        print(k)
        k_values.append(k)
        (similarity_degree_permuted, flattened_perms, X_sorted, model) = run(subsampled_X, k)
        rss_values.append(model.rss_)
        f.write(f"k={k}, j={j}, RSS={model.rss_}\n")
        print(f"k={k}, j={j}, RSS={model.rss_}")