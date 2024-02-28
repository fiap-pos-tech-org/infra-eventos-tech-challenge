# infra-eventos-tech-challenge
Event-driven AWS resource terraform files

#### Lista de recursos:
##### Filas
- fila_pagamento_aprovado
- fila_pagamento_reprovado
- fila_pagamento_cancelado
- fila_pedido_pronto.fifo
- fila_producao.fifo
- fila_pagamento_pendente


##### Tópicos
- topico_pagamento_retorno
- topico_pagamento_pendente
- topico_producao.fifo


#### Vínculos:
> topico_pagamento_pendente -> fila_pagamento_pendente

> topico_producao_FIFO -> fila_producao_FIFO (pedido status = "PENDENTE")

> topico_producao_FIFO -> fila_pedido_pronto_FIFO (pedido status = "PRONTO")

> topico_pagamento_retorno -> fila_pagamento_aprovado (pagamento status = "APROVADO")

> topico_pagamento_retorno -> fila_pagamento_reprovado (pagamento status = "REPROVADO")

> topico_pagamento_retorno -> fila_pagamento_cancelado (pagamento status = "CANCELADO")