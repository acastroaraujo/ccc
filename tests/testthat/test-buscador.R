

# api-tests-NOT-for-rcmdcheck ---------------------------------------------

# test_that("underlying database has not changed", {
#   results <- ccc_search(text = "", date_start = "1992-04-01", date_end = "1992-04-30")
#   
#   out1 <- ccc_clean_dataset(results) |> 
#     dplyr::mutate(type = factor(type, levels = c("C", "SU", "T"))) |> 
#     dplyr::filter(id == "T-001-92")
#   
#   out2 <- metadata |> 
#     dplyr::filter(id == "T-001-92") |> 
#     dplyr::select(-indegree, -outdegree, -word_count)
#   
#   expect_equal(out1, out2)
# })
# 
# 
# test_that("search isn't setting a limit on results", {
#   
#   results <- ccc_search(
#     text = "familia", 
#     date_start = "2000-01-01", 
#     date_end = "2001-12-31"
#   )
#   
#   website <- httr::GET("https://www.corteconstitucional.gov.co/relatoria/buscador_new/?searchOption=texto&fini=2000-01-01&ffin=2001-12-31&buscar_por=familia&accion=search&verform=si&slop=1&buscador=buscador&qu=search_principalMatch&maxprov=100&OrderbyOption=des__score&tot_provi_found=1&tot_provi_show=1", httr::user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36"))
#   
#   total_number <- website |> 
#     rvest::read_html() |> 
#     rvest::html_element("#tot_prov_filtro") |> 
#     rvest::html_text()
#   
#   total_number <- as.numeric(gsub(",", "", total_number))
#   
#   expect_equal(nrow(results), total_number)
#   
# })



