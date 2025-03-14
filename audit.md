# Audit

---

| Location | Task | IP        | Latency | Bandwidth (Mbit/s) | Cost | Host Network IP |
| -------- | ---- | --------- | ------- | ------------------ | ---- | --------------- |
| LOND     | HAML | 77.0.2.1  | 2.129   | 103-107            | 5    | 77.101.0.1      |
| LOND     | PARI | 77.0.4.1  | 0.167   | 103-106            | 2    | 77.101.0.1      |
| LOND     | NEWY | 77.0.8.2  | 0.312   | 10.2-13.0          | 4    | 77.101.0.1      |
| LOND     | BOST | 77.0.7.2  | 20.162  | 102-105            | 20   | 77.101.0.1      |
| HAML     | PARI | 77.0.1.2  | 0.303   | 103-106            | 3    | 77.102.0.1      |
| HAML     | LOND | 77.0.2.2  | 2.127   | 103-107            | 5    | 77.102.0.1      |
| PARI     | LOND | 77.0.4.2  | 0.170   | 103-106            | 2    | 77.103.0.1      |
| PARI     | HAML | 77.0.1.1  | 0.322   | 103-106            | 3    | 77.103.0.1      |
| PARI     | TRGA | 77.0.3.2  | 0.163   | 103-106            | 2    | 77.103.0.1      |
| PARI     | ZURI | 77.0.6.2  | 0.210   | 103-106            | 2    | 77.103.0.1      |
| PARI     | NEWY | 77.0.5.2  | 2.165   | 10.2-12.5          | 5    | 77.103.0.1      |
| TRGA     | ZURI | 77.0.9.1  | 0.316   | 0.975-1.75         | 10   | 77.104.0.1      |
| TRGA     | PARI | 77.0.3.1  | 0.227   | 103-106            | 2    | 77.104.0.1      |
| NEWY     | BOST | 77.0.10.2 | 10.385  | 10.2-13.3          | 15   | 77.105.0.1      |
| NEWY     | LOND | 77.0.8.1  | 0.308   | 10.2-13.0          | 4    | 77.105.0.1      |
| NEWY     | PARI | 77.0.5.1  | 2.146   | 10.212.5           | 5    | 77.105.0.1      |
| NEWY     | ZURI | 77.0.12.2 | 0.113   | 103-106            | 1    | 77.105.0.1      |
| NEWY     | ATLA | 77.0.11.2 | 0.297   | 103-106            | 3    | 77.105.0.1      |
| BOST     | LOND | 77.0.7.1  | 20.176  | 102-105            | 20   | 77.106.0.1      |
| BOST     | NEWY | 77.0.10.1 | 10.305  | 10.2-13.3          | 15   | 77.106.0.1      |
| ATLA     | NEWY | 77.0.11.1 | 0.321   | 103-106            | 3    | 77.107.0.1      |
| ATLA     | ZURI | 77.0.13.2 | 0.339   | 103-106            | 3    | 77.107.0.1      |
| ZURI     | ATLA | 77.0.13.1 | 0.301   | 103-106            | 3    | 77.108.0.1      |
| ZURI     | NEWY | 77.0.12.1 | 0.144   | 103-106            | 1    | 77.108.0.1      |
| ZURI     | PARI | 77.0.6.1  | 0.211   | 103-106            | 2    | 77.108.0.1      |
| ZURI     | TRGA | 77.0.9.2  | 0.334   | 0.975-1.75         | 10   | 77.108.0.1      |

Route from BOST to PARI

- Before
  - BOST -> LOND -> PARI `cost: 22`
- After
  - BOST -> NEWY -> PARI `cost: 20`

`22 - 20 = 2` saved
