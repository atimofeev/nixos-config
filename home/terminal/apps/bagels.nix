{ pkgs, ... }:
{

  home.packages = with pkgs; [ bagels ];

  # NOTE: https://github.com/EnhancedJax/Bagels/issues/77
  # xdg.configFile."bagels/config.yaml" = {
  #   force = true;
  #   text = # yaml
  #     ''
  #       defaults:
  #         date_format: '%d/%m'
  #         first_day_of_week: 6
  #         period: week
  #         plot_marker: braille
  #         round_decimals: 2
  #       hotkeys:
  #         categories:
  #           browse_defaults: b
  #           new_subcategory: s
  #         delete: d
  #         edit: e
  #         home:
  #           advance_filter: f
  #           budgets: b
  #           cycle_offset_type: .
  #           cycle_tabs: c
  #           datemode:
  #             go_to_day: g
  #           display_by_date: q
  #           display_by_person: w
  #           new_transfer: t
  #           select_next_account: ']'
  #           select_prev_account: '['
  #           toggle_income_mode: /
  #           toggle_splits: s
  #           toggle_use_account: \
  #         new: a
  #         record_modal:
  #           delete_last_split: ctrl+d
  #           new_paid_split: ctrl+s
  #           new_split: ctrl+a
  #         toggle_jump_mode: v
  #       state:
  #         budgeting:
  #           income_assess_fallback: 3500
  #           income_assess_metric: periodIncome
  #           income_assess_threshold: 100
  #           savings_amount: 0
  #           savings_assess_metric: percentagePeriodIncome
  #           savings_percentage: 0.2
  #           wants_spending_amount: 0
  #           wants_spending_assess_metric: percentageQuota
  #           wants_spending_percentage: 0.2
  #         check_for_updates: false
  #         footer_visibility: true
  #         theme: catppuccin-mocha
  #       symbols:
  #         amount_negative: '-'
  #         amount_positive: +
  #         category_color: "●"
  #         finish_line_char: "╰"
  #         line_char: "│"
  #         split_paid: "✓"
  #         split_unpaid: "⨯"
  #     '';
  # };

}
