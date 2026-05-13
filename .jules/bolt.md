## 2024-05-13 - Optimize nested loops for house positions
**Learning:** Found multiple places doing `.where((p) => p.house == X)` inside loops that render chart data, resulting in O(N*M) complexity where N is planets and M is cells/rows. Since planets list is small (~12), it might seem fine, but grouping them once into a Map<int, List<PlanetPosition>> provides an O(N+M) solution.
**Action:** Use a pre-computed map of houses to planets for `_drawNorthIndianHouses` to reduce list iterations from 12*9 to 12+9.
