# CacheSimulatorRep

Members:
- Maria Alejandra Estrada Garcia (11151775)
- Samer Omar Ayoub (11151229)

# Building the Project

Verify the presence of basesim \\

Compile the modified simulator:

```bash
make
```

The generated executable is:

```text
sim
```

(or `sim.exe` on Windows).

---

# Running the Original Tests

Run a single input and compare against the baseline simulator:

```bash
make run INPUT=inputs/inst/addiu.x
```

Run multiple tests:

```bash
make run INPUT=inputs/inst/*.x
```

Run all provided tests:

```bash
make run
```

The output of `sim` should always match the output of `basesim`. The cycle count and IPC will differ because the modified simulator models cache timing.

---

# Running Benchmarks

The simulator was extended to allow cache parameters and cache policies to be selected directly from the command line.

General syntax:

```bash
python run.py <benchmark.x> --cache <I_sets> <I_assoc> <I_block> <D_sets> <D_assoc> <D_block> --policies <replacement_policy> <insertion_policy>
```

Example:

```bash
python run.py inputs/benchmarks/random_access_complex.x --cache 64 4 32 256 8 32 --policies 2 0
```

---

# Cache Parameters

The six values following `--cache` correspond to:

```text
Instruction Cache
-----------------
I_sets
I_assoc
I_block

Data Cache
----------
D_sets
D_assoc
D_block
```

Example:

```bash
--cache 64 4 32 256 8 32
```

means

```text
Instruction Cache
-----------------
64 sets
4-way associativity
32-byte blocks
Capacity = 64 × 4 × 32 = 8 KB

Data Cache
----------
256 sets
8-way associativity
32-byte blocks
Capacity = 256 × 8 × 32 = 64 KB
```

The cache capacity is computed as

```text
Cache Capacity = Number of Sets × Associativity × Block Size
```

Only valid cache organizations should be used (the resulting number of sets must be a positive power of two).

---

# Replacement Policies

The first value after `--policies` selects the replacement policy.

| Value | Replacement Policy |
|-------:|--------------------|
| 0 | LRU |
| 1 | MRU |
| 2 | FIFO |
| 3 | Random |

Example:

```bash
--policies 2 0
```

uses the **FIFO** replacement policy.

---

# Insertion Policies

The second value after `--policies` selects the insertion policy.

| Value | Insertion Policy |
|-------:|------------------|
| 0 | MRU insertion |
| 1 | LRU insertion |

Example:

```bash
--policies 2 0
```

means

```text
Replacement Policy : FIFO
Insertion Policy   : MRU
```

---

# Running Benchmarks from Python

The following helper function was used to automate the experiments:

```python
def run_benchmark(
    benchmark_file_path,
    isets,
    iasso,
    iblock,
    dsets,
    dasso,
    dblock,
    repl_policy=0,
    insert_policy=0):

    result = subprocess.run(
        [
            "python",
            "run.py",
            benchmark_file_path,
            "--cache",
            str(isets),
            str(iasso),
            str(iblock),
            str(dsets),
            str(dasso),
            str(dblock),
            "--policies",
            str(repl_policy),
            str(insert_policy)
        ],
        cwd=cachesim_path,
        capture_output=True,
        text=True,
        check=True
    )

    return result
```

This function executes a benchmark using the selected cache configuration and replacement/insertion policies.

---

# Cache Parameter Ranges

The cache parameter evaluation used the following ranges:

| Parameter | Values |
|-----------|--------|
| Cache Size | 1 KB, 2 KB, 4 KB, 8 KB, 16 KB, 32 KB, 64 KB |
| Block Size | 8 B, 16 B, 32 B, 64 B, 128 B, 256 B |
| Associativity | 2-way, 4-way, 8-way, 16-way, 32-way |

Only valid cache organizations were evaluated.

---

# Replacement/Insertion Policy Evaluation

For the policy evaluation, the data cache configuration was kept fixed to isolate the effect of the replacement and insertion policies.

Configuration used:

```text
Cache Size      : 1 KB
Associativity   : 4-way
Block Size      : 16 B
Number of Sets  : 16
```

Example command:

```bash
python run.py inputs/benchmarks/conflict_access_complex.x --cache 64 4 32 16 4 16 --policies 1 0
```

This configuration corresponds to:

```text
Instruction Cache
-----------------
64 sets
4-way
32-byte blocks
(8 KB)

Data Cache
----------
16 sets
4-way
16-byte blocks
(1 KB)

Replacement Policy : MRU
Insertion Policy   : MRU
```

---

# Benchmarks Included

The benchmark suite includes:

```text
streaming_array_complex.x
conflict_access_complex.x
random_access_complex.x
store_heavy_complex.x
repeated_large_working_set.x
conv2d_row_major_128.x
conv2d_column_major_128.x
```

The corresponding `.s` files contain the MIPS assembly source code used to generate each executable `.x` benchmark.
