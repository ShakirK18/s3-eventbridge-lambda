resource "aws_sns_topic" "test" {
  name = "test-policy"
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.test.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values   = [var.account_id]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [aws_sns_topic.test.arn]
    sid       = "__default_statement_ID"
  }

  statement {
    actions = ["SNS:Publish"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.test.arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [module.eventbridge.eventbridge_rule_arns["s3_image_uploaded"]]
    }

    sid = "AllowEventBridgePublish"
  }

#   above allows both accountID & service principal to push to sns topic - differentation is needed here to work
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.test.arn
  protocol  = "email"
  endpoint  = "shakir.kabir@scalefactory.com"
}