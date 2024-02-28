resource "aws_sqs_queue" "fila_pagamento_aprovado" {
  name          = var.fila_pagamento_aprovado
  delay_seconds = 60

  tags = {
    Environment = "techchallenge"
    Engine      = "terraform"
  }
}

resource "aws_sqs_queue" "fila_pagamento_reprovado" {
  name          = var.fila_pagamento_reprovado
  delay_seconds = 60

  tags = {
    Environment = "techchallenge"
    Engine      = "terraform"
  }
}

resource "aws_sqs_queue" "fila_pagamento_cancelado" {
  name          = var.fila_pagamento_cancelado
  delay_seconds = 60

  tags = {
    Environment = "techchallenge"
    Engine      = "terraform"
  }
}

resource "aws_sqs_queue" "fila_pedido_pronto_fifo" {
  name                        = var.fila_pedido_pronto_fifo
  delay_seconds               = 60
  fifo_queue                  = true
  content_based_deduplication = true

  tags = {
    Environment = "techchallenge"
    Engine      = "terraform"
  }
}

resource "aws_sqs_queue" "fila_producao_fifo" {
  name                        = var.fila_producao_fifo
  delay_seconds               = 60
  fifo_queue                  = true
  content_based_deduplication = true

  tags = {
    Environment = "techchallenge"
    Engine      = "terraform"
  }
}

resource "aws_sqs_queue" "fila_pagamento_pendente" {
  name          = var.fila_pagamento_pendente
  delay_seconds = 60

  tags = {
    Environment = "techchallenge"
    Engine      = "terraform"
  }
}

resource "aws_sns_topic" "topico_pagamento_retorno" {
  name = var.topico_pagamento_retorno

  tags = {
    Environment = "techchallenge"
    Engine      = "terraform"
  }
}

resource "aws_sns_topic" "topico_pagamento_pendente" {
  name = var.topico_pagamento_pendente

  tags = {
    Environment = "techchallenge"
    Engine      = "terraform"
  }
}

resource "aws_sns_topic" "topico_producao_fifo" {
  name                        = var.topico_producao_fifo
  fifo_topic                  = true
  content_based_deduplication = true

  tags = {
    Environment = "techchallenge"
    Engine      = "terraform"
  }
}

resource "aws_sns_topic_subscription" "topico_producao_fifo_sqs_producao_fifo" {
  topic_arn = aws_sns_topic.topico_producao_fifo.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.fila_producao_fifo.arn
}

resource "aws_sns_topic_subscription" "topico_producao_fifo_sqs_pedido_pronto_fifo" {
  topic_arn = aws_sns_topic.topico_producao_fifo.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.fila_pedido_pronto_fifo.arn
}

resource "aws_sns_topic_subscription" "topico_pagamento_retorno_sqs_pagamento_pendente" {
  topic_arn = aws_sns_topic.topico_pagamento_pendente.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.fila_pagamento_pendente.arn
}

resource "aws_sns_topic_subscription" "topico_pagamento_retorno_sqs_pagamento_aprovado" {
  topic_arn = aws_sns_topic.topico_pagamento_retorno.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.fila_pagamento_aprovado.arn
}

resource "aws_sns_topic_subscription" "topico_pagamento_retorno_sqs_pagamento_reprovado" {
  topic_arn = aws_sns_topic.topico_pagamento_retorno.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.fila_pagamento_reprovado.arn
}

resource "aws_sns_topic_subscription" "topico_pagamento_retorno_sqs_pagamento_cancelado" {
  topic_arn = aws_sns_topic.topico_pagamento_retorno.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.fila_pagamento_cancelado.arn
}

