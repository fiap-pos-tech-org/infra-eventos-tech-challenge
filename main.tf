data "aws_iam_policy_document" "iam_sqs_send_policy" {
  statement {
    sid    = "send_message"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = ["arn:aws:sqs:us-east-1:720502424322:*"]
  }
}

resource "aws_sqs_queue" "fila_pagamento_aprovado" {
  name          = var.fila_pagamento_aprovado
  delay_seconds = 60
  policy        = data.aws_iam_policy_document.iam_sqs_send_policy.json

  tags = {
    Environment = "techchallenge"
    Engine      = "terraform"
  }
}

resource "aws_sqs_queue" "fila_pagamento_recusado" {
  name          = var.fila_pagamento_recusado
  delay_seconds = 60
  policy        = data.aws_iam_policy_document.iam_sqs_send_policy.json

  tags = {
    Environment = "techchallenge"
    Engine      = "terraform"
  }
}

resource "aws_sqs_queue" "fila_pagamento_cancelado" {
  name          = var.fila_pagamento_cancelado
  delay_seconds = 60
  policy        = data.aws_iam_policy_document.iam_sqs_send_policy.json

  tags = {
    Environment = "techchallenge"
    Engine      = "terraform"
  }
}

resource "aws_sqs_queue" "fila_pedido_pronto_fifo" {
  name                        = var.fila_pedido_pronto_fifo
  delay_seconds               = 60
  policy                      = data.aws_iam_policy_document.iam_sqs_send_policy.json
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
  policy                      = data.aws_iam_policy_document.iam_sqs_send_policy.json
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
  policy        = data.aws_iam_policy_document.iam_sqs_send_policy.json

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

  filter_policy = <<POLICY
  {
    "status": ["EM_PREPARACAO"]
  }
  POLICY

  filter_policy_scope = "MessageBody"

  depends_on = [
    aws_sns_topic.topico_producao_fifo,
    aws_sqs_queue.fila_producao_fifo
  ]
}

resource "aws_sns_topic_subscription" "topico_producao_fifo_sqs_pedido_pronto_fifo" {
  topic_arn = aws_sns_topic.topico_producao_fifo.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.fila_pedido_pronto_fifo.arn

  filter_policy = <<POLICY
  {
    "status": ["PRONTO"]
  }
  POLICY

  filter_policy_scope = "MessageBody"

  depends_on = [
    aws_sns_topic.topico_producao_fifo,
    aws_sqs_queue.fila_pedido_pronto_fifo
  ]
}

resource "aws_sns_topic_subscription" "topico_pagamento_pendente_sqs_pagamento_pendente" {
  topic_arn = aws_sns_topic.topico_pagamento_pendente.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.fila_pagamento_pendente.arn

  depends_on = [
    aws_sns_topic.topico_pagamento_pendente,
    aws_sqs_queue.fila_pagamento_pendente
  ]
}

resource "aws_sns_topic_subscription" "topico_pagamento_retorno_sqs_pagamento_aprovado" {
  topic_arn = aws_sns_topic.topico_pagamento_retorno.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.fila_pagamento_aprovado.arn

  filter_policy = <<POLICY
  {
    "status": ["RECEBIDO"]
  }
  POLICY

  filter_policy_scope = "MessageBody"

  depends_on = [
    aws_sns_topic.topico_pagamento_retorno,
    aws_sqs_queue.fila_pagamento_aprovado
  ]
}

resource "aws_sns_topic_subscription" "topico_pagamento_retorno_sqs_pagamento_recusado" {
  topic_arn = aws_sns_topic.topico_pagamento_retorno.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.fila_pagamento_recusado.arn

  filter_policy = <<POLICY
  {
    "status": ["RECUSADO"]
  }
  POLICY

  filter_policy_scope = "MessageBody"

  depends_on = [
    aws_sns_topic.topico_pagamento_retorno,
    aws_sqs_queue.fila_pagamento_recusado
  ]
}

resource "aws_sns_topic_subscription" "topico_pagamento_retorno_sqs_pagamento_cancelado" {
  topic_arn = aws_sns_topic.topico_pagamento_retorno.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.fila_pagamento_cancelado.arn

  filter_policy = <<POLICY
  {
    "status": ["CANCELADO"]
  }
  POLICY

  filter_policy_scope = "MessageBody"

  depends_on = [
    aws_sns_topic.topico_pagamento_retorno,
    aws_sqs_queue.fila_pagamento_cancelado
  ]
}
