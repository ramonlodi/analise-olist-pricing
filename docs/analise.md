# Análise e insights: PVM por categoria

**Pergunta de negócio:** onde a receita cresce ou cai por categoria, quanto dessa variação vem de preço, volume ou mix, e o que isso sugere para decisões de preço e portfólio?

**Recorte:** jan–ago/2017 vs jan–ago/2018, pedidos entregues, receita = preço dos itens (sem frete).
**Fonte dos números:** `gold.pvm_categoria` (exportada em `docs/csv/pvm_categoria.csv`). As consultas que reproduzem cada número estão em `sql/06_insights_validacao.sql`.

---

## Resumo

1. A receita mais que dobrou (+141%), quase toda por **volume**. Isso é esperado: o efeito volume aplica o mesmo crescimento de unidades (+141,8%) a toda categoria, então ele não diferencia categorias. A informação está em **preço e mix**.
2. O preço médio por item ficou praticamente estável (−0,3%), mas, na mesma cesta de produtos, o preço **caiu cerca de 4,6%**. A mudança de composição entre categorias compensou a queda.
3. A queda de preço está **concentrada em poucas categorias**, e a mais relevante, Relógios Presentes, cresceu muito abaixando preço.
4. O crescimento líquido também é concentrado: 10 categorias respondem por 68%.

## Resultado geral

| Métrica | Jan–ago/2017 | Jan–ago/2018 | Variação |
|---|---|---|---|
| Receita | R$ 2.993.456,13 | R$ 7.218.125,12 | +R$ 4.224.668,99 (+141,1%) |
| Unidades | 24.943 | 60.324 | +141,8% |
| Preço médio por item | R$ 120,01 | R$ 119,66 | −0,3% |

| Componente | Efeito na receita |
|---|---|
| Preço | −R$ 344.988,73 |
| Volume | +R$ 4.245.880,04 |
| Mix | +R$ 323.777,68 |
| **Total** | **+R$ 4.224.668,99** |

Preço + volume + mix fecham com a variação total da receita (reconciliado em `sql/05_pvm_categoria.sql`).

---

## Insights

### 1. O preço médio estável esconde uma queda de preço de ~4,6%

- O preço médio por item foi de R$ 120,01 para R$ 119,66 (−0,3%).
- Comparando a mesma cesta de 2018 a preços de 2017 e de 2018 (categorias contínuas), o preço caiu **4,6%**. Só na base confiável (31 categorias com ≥100 unidades em 2017), a queda é de **4,2%**.
- O efeito preço de −R$ 345 mil equivale a esses ~4,6% sobre a receita de 2018 calculada a preços de 2017 (R$ 7,56 mi).
- A diferença entre os dois números vem da composição: o peso das categorias de ticket mais alto aumentou, o que empurra o preço médio total para cima em cerca de 4,5% e anula a queda de preço.

**Por que importa:** quem acompanhasse só o preço médio concluiria que não houve mudança de preço. O preço médio total mistura preço com composição, e por isso não serve como indicador de política de preço.

### 2. A queda de preço está concentrada em 3 categorias, e Relógios Presentes é o caso-chave

- 36 categorias contínuas tiveram efeito preço negativo (soma de −R$ 889 mil) e 34 tiveram efeito positivo (+R$ 544 mil). O líquido é −R$ 345 mil.
- Três categorias somam **−R$ 358 mil**, mais que todo o efeito líquido:

| Categoria | Preço médio 2017 → 2018 | Unidades 2017 → 2018 | Efeito preço |
|---|---|---|---|
| Relógios Presentes | R$ 239,74 → R$ 189,60 (−20,9%) | 839 → 3.628 (+332%) | −R$ 181,9 mil |
| Informática Acessórios | R$ 129,45 → R$ 107,37 (−17,1%) | 1.658 → 4.622 (+179%) | −R$ 102,1 mil |
| Automotivo | R$ 161,82 → R$ 133,06 (−17,8%) | 774 → 2.580 (+233%) | −R$ 74,2 mil |

- **Relógios Presentes** cresceu +332% em unidades com preço 21% menor. A receita foi de R$ 201 mil para R$ 688 mil (3,4 vezes), e a participação na receita total subiu de 6,7% para 9,5%.
- Seu efeito mix (+R$ 383 mil) é **maior que o mix total** (+R$ 324 mil): é a categoria que mais puxou a composição para cima.

**Por que importa:** são categorias de ticket mais alto, onde o preço pesa mais. Sem custo e margem, não dá para saber se esse crescimento com preço menor foi bom para o negócio ou só receita mais cara de conseguir.

### 3. O crescimento é concentrado, e Beleza Saúde cresce sem sacrificar preço

- Top 3 categorias = **30,8%** do crescimento líquido da receita. Top 5 = 44,0%. Top 10 = **67,6%**.
- **Beleza Saúde** é a primeira, com +R$ 512 mil (12,1% do crescimento líquido): unidades de 1.822 para 5.841 (+221%) e preço praticamente estável (R$ 133,66 → R$ 129,38, −3,2%). O efeito preço é de apenas −R$ 25 mil.

**Por que importa:** o crescimento de Beleza Saúde é quase todo volume e mix, sem depender de desconto, o que o diferencia de Relógios Presentes e Informática Acessórios.

### 4. Duas categorias grandes ficaram para trás, e a causa não foi preço

O mix só é negativo quando a categoria cresce abaixo da média (+141,8%):

| Categoria | Unidades | Preço médio | Receita | Efeito mix |
|---|---|---|---|---|
| Cool Stuff | 1.262 → 1.447 (+14,7%) | R$ 163,48 → R$ 157,39 (−3,7%) | R$ 206 mil → R$ 228 mil (+10,4%) | −R$ 262,4 mil |
| Brinquedos | 1.059 → 1.454 (+37,3%) | R$ 111,85 → R$ 115,63 (+3,4%) | R$ 118 mil → R$ 168 mil (+41,9%) | −R$ 123,8 mil |

- O preço quase não mudou nelas. O que mudou foi o volume em comparação com o resto do marketplace.
- Em contrapartida, o mix de Relógios Presentes (+R$ 383 mil), Beleza Saúde (+R$ 192 mil) e Automotivo (+R$ 115 mil) compensa essas perdas.
- Categorias novas e descontinuadas quase não pesam no mix (+R$ 5,9 mil). O mix vem de realocação entre categorias que já existiam.

**Por que importa:** o portfólio que mais crescia puxou o peso para longe de Cool Stuff e Brinquedos. Vale investigar sortimento, exposição e disponibilidade nelas, e não preço.

### 5. Preço e volume: o sinal é fraco

Entre as 31 categorias da base confiável:

- As 16 com preço em queda tiveram crescimento mediano de unidades de **+136%**. As 15 com preço em alta tiveram **+81%**.
- 8 das 16 com preço em queda cresceram acima da média (+141,8%), contra 4 das 15 com preço em alta.
- Entre as que subiram preço, os resultados são mistos:
  - **Utilidades Domésticas:** preço +26,6% e unidades +143% (em linha com a média).
  - **Bebês:** preço +26,9% e unidades +190%.
  - **Móveis Decoração:** preço +20,3% e unidades +86% (abaixo da média).

**Por que importa:** a relação existe, mas é fraca e com poucas categorias. Isso sugere que subir preço não derrubou o volume em todas as categorias, e não permite dizer que baixar preço gera volume.

---

## Recomendações

As recomendações são **hipóteses a testar**, não conclusões. Os dados são observacionais e não têm custo nem margem.

1. **Acompanhar o preço como índice de mesma cesta, e não só como preço médio.** O preço médio ficou em −0,3% enquanto o índice de mesma cesta caiu ~4,6%. Um índice trimestral por categoria teria mostrado a queda antes.
2. **Auditar as 3 categorias com maior queda de preço antes de novos descontos** (Relógios Presentes, Informática Acessórios e Automotivo). Cruzar com custo e margem para saber se o volume adicional compensou os R$ 358 mil de efeito preço. Se não houver margem disponível, testar por região ou período, e não em toda a categoria.
3. **Testar reajustes controlados onde o volume resistiu à alta de preço**: Utilidades Domésticas e Bebês. Todo o resto constante, +1% de preço equivale a cerca de R$ 3,9 mil (Utilidades Domésticas) e R$ 2,5 mil (Bebês) sobre a receita de 2018. O ganho só se confirma se o volume se mantiver, e por isso o teste vem antes da decisão.
4. **Investigar Cool Stuff e Brinquedos pelo lado de sortimento e exposição.** O preço delas quase não mudou, mas elas ficaram para trás num marketplace que cresceu 141%. E **proteger Beleza Saúde**, a maior fonte de crescimento sem desconto.

### Próximos passos de dados

- Incluir custo e margem para trocar "receita" por "lucro" nas decisões de preço.
- Repetir o PVM por estado. A camada Gold já tem o estado, mas o PVM foi feito só por categoria.

---

## Limitações

- **Dados observacionais.** O PVM descreve a variação, mas não prova causa.
- **Sem custo ou margem.** Não dá para dizer se uma queda de preço foi boa ou ruim.
- **Período curto e de expansão.** Os dados vão de 2016 a 2018, e a base de jan–ago/2017 é pequena (24.943 unidades). O crescimento reflete a expansão do marketplace e não o mercado.
- **Volume uniforme por construção.** O efeito volume aplica o mesmo crescimento a todas as categorias. Quem diferencia categorias é preço e mix.
- **O efeito preço inclui troca de produtos dentro da categoria.** Se uma categoria vendeu produtos mais baratos, isso aparece como queda de preço.
- **Só pedidos entregues.** Itens de pedidos não entregues (2.453) ficam fora, por decisão.
- **Categoria nula.** 610 produtos (1,85%) estão sem categoria e aparecem como "Sem categoria". Isso representa cerca de 1% da receita de 2018.
- **Base confiável.** A análise de preço × volume considera só as 31 de 74 categorias com ≥100 unidades em jan–ago/2017. Telefonia Fixa (preço +294%, 100 unidades) fica fora da escala do gráfico.
- **Datas em UTC.** Um pedido tarde da noite pode cair no dia seguinte.
- **Estado.** O recorte por estado existe no Gold e no Looker Studio, mas o PVM não foi decomposto por estado.