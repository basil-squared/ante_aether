return {
    descriptions = {
        Back = {},
        Blind = {},
        Edition = {},
        Enhanced = {},
        Joker = {
            j_ante_aether_mana_battery = {
                name = "Mana Battery",
                text = {
                    "{C:attention}Surge:{} Gains {X:mult,C:white}X#1#{} Mult",
                    "{C:inactive,S:0.7}(resets at end of round){}"
                },
                flavor_text = {
                    '{C:inactive,S:0.8}"A single whisper, trapped in glass,{}',
                    '{C:inactive,S:0.8}repeating until it shatters the world."{}'
                }
            },
            j_ante_aether_tesla_bulb = {
                name = "Tesla Bulb",
                text = {
                    "{C:attention}Scores{} all",
                    "{C:enhanced}Steel{} and {C:enhanced}Gold{} cards",
                    "{C:attention}held in hand{}",
                    "{C:attention}#1#{} additional #2#"

                },
                flavor_text = {
                    '{C:inactive,S:0.8}"Look ma, no wires!"'
                }
            },
            j_ante_aether_alternator = {
                name = "Alternator",
                text = {
                    "{C:attention}Scores{} the",
                    "{C:attention}second{} and {C:attention}fourth{} cards",
                    "in scored hand",
                    "{C:attention}#1#{} additional #2#"
                },
                flavor_text = {
                    '{C:inactive,S:0.8}"Up.. down.. up... down...'
                }

            },
            j_ante_aether_superconductor = {
                name = "Superconductor",
                text = {
                    "{C:attention}Surge:{} {X:mult,C:white}X#1#{} Mult"
                },
                flavor_text = {
                    '{C:inactive,S:0.8}"Zero resistance, yet somehow infinite potential.',
                    '{C:inactive,S:0.8}How curious. - Perkeo, Avatar of Resonance'
                }
            },
            j_ante_aether_jumper_cable = { -- Common
                name = "Jumper Cable",
                text = {
                    "Score the",
                    "{C:attention}first{} card of scored hand",
                    "{C:attention}#1#{} additional #2#"
                },
                flavor_text = {
                    '{C:inactive,S:0.8}"Clear!"'
                }

            },
            j_ante_aether_leyline_map = { -- Uncommon
                name = 'Leyline Map',
                text = {
                    "{C:attention}Surge:{} Surged card",
                    "{C:attention}permanently{} gains {C:chips}+#1#{} Chips"

                },
                flavor_text = {
                    '{C:inactive,S:0.8}"Most artificers skip over the good leylines.',
                    '{C:inactive,S:0.8}We, however, are not most artificers."'
                }
            },
            j_ante_aether_repeater = { -- Rare
                name = "Repeater",
                text = {
                    "Scored {C:attention}High Cards{}",
                    "are scored {C:attention}#1#{} additional #2#",
                    "and {C:red}discards{} all cards",
                    "{C:attention}held in hand{}",
                    "after scoring"
                },
                flavor_text = {
                    '{C:inactive,S:0.8}"Signal boosted. Bandwidth consumed.'
                }
            },
            j_ante_aether_line_tapper = { -- Uncommon
                name = "Line Tapper",
                text = {
                    "Whenever a ",
                    "{C:planet}Blue{} or {C:tarot}Purple{} Seal trigger,",
                    "gain {C:attention}$#1#{}"
                },
                flavor_text = {
                    '{C:inactive,S:0.8}"They surely won\'t miss this..."'
                }
            },
            j_ante_aether_switchboard = { -- Rare
                name = "Switchboard",
                text = {
                    "Swaps {C:chips} Chips{} and {C:mult}Mult{} values of",
                    "{C:attention}played cards{}"

                },
                flavor_text = {
                    '{C:inactive,S:0.8}"Connecting.. hold, please.."'
                }
            },
            j_ante_aether_sympathy = { -- Uncommon
                name = "Sympathy",
                text = {
                    "If the first played card is a {C:attention}Face Card{},",
                    "Transmits {C:attention}Suit{} to other played cards."
                },
                flavor_text = {
                    '{C:inactive,S:0.8}"As above, so below. As one, so all."'
                }
            },
            j_ante_aether_grave_robber = {
                name = "Grave Robber",
                text = {
                    "If a card were to be {C:attention}destroyed,",
                    "{C:green}#1# in #2#{} to instead",
                    "add it to {C:attention}hand{}"
                },
                flavor_text = {
                    '{C:inactive,S:0.8}"It\'s lucrative alright.',
                    '{C:inactive,S:0.8}As long as you dont have dignity.'
                }
            },
            j_ante_aether_polymerization = { -- Common
                name = "Polymerization",
                text = {
                    "If played hand has exactly",
                    "{C:attention}#1#{} cards, {C:attention}combine{} them",
                    "into a card with {C:attention}Rank{}",
                    "equal to their {C:attention}sum{}",
                    "{C:green}#2# in #3#{} chance to revert",
                    "to component cards when scored",
                    "{C:inactive}(Max sum: 10){}"
                },
                flavor_text = {
                    "{C:inactive,S:0.8}Combination successful.",
                    "{C:inactive,S:0.8}Integrity questionable."
                }
            },
            j_ante_aether_perpetual_motion = {
                name = "Perpetual Motion",
                text = {
                    "{C:attention}Module A:{} Hand must be a {C:attention}#1#{}.",
                    "{C:attention}Module B:{} Hand must contain {C:attention}#3#{}.",
                    "{C:red}Module C:{} Hand must {C:red}NOT{} contain {C:attention}#2#{}.",
                    "{C:inactive}(Restriction active only if hand contains {C:attention}#3#{}){C:inactive}.",
                    "{C:green}Current Output:{} #5#",
                    "{C:inactive,s:0.8}Current State: #4#{}"
                },
                flavor_text = {
                    "{C:inactive,S:0.8}\"Run that by me again?\""
                }
            },
            j_ante_aether_spillway = {
                name = "The Spillway",
                text = {
                    "Hand size limit is {C:attention}Infinite{}",
                },
                flavor_text = {
                    "{C:inactive,S:0.8}\"The dam is gone. The river takes all.\""
                }
            }
        },
        Other = {
            ante_aether_surge_info = {
                name = "Surge",
                text = {
                    "Triggers when a card",
                    "is {C:attention}retriggered{}",
                },
            },
        },
        Planet = {
            c_ante_aether_planet_hydra = {
                name = "Nibiru",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}The Hydra{}",
                    "{C:mult}+#2#{} Mult and",
                    "{C:chips}+#3#{} chips"
                }
            },
            c_ante_aether_planet_double_trinity = {
                name = "Ixion",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}Double Trinity{}",
                    "{C:mult}+#2#{} Mult and",
                    "{C:chips}+#3#{} chips"
                }
            },
            c_ante_aether_planet_council = {
                name = "Varuna",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}The Council{}",
                    "{C:mult}+#2#{} Mult and",
                    "{C:chips}+#3#{} chips"
                }
            },
            c_ante_aether_planet_singularity = {
                name = "Nemesis",
                text = {
                    "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
                    "{C:attention}The Entire Deck{}",
                    "{C:mult}+#2#{} Mult and",
                    "{C:chips}+#3#{} chips"
                }
            }
        },
        Spectral = {},
        Stake = {},
        Tag = {},
        Tarot = {},
        Voucher = {},
        PokerHand = {
            The_Hydra = {
                name = "The Hydra",
                description = {
                    "3 distinct Pairs",
                    "(6 cards)"
                }
            },
            Double_Trinity = {
                name = "Double Trinity",
                description = {
                    "2 sets of Three-of-a-Kind",
                    "(6 cards)"
                }
            },
            The_Council = {
                name = "The Council",
                description = {
                    "5 Face Cards containing",
                    "J, Q, and K"
                }
            },
            The_Singularity = {
                name = "The Entire Deck",
                description = {
                    "Every single card",
                    "in your deck"
                }
            }
        }
    },
    misc = {
        achievement_descriptions = {},
        achievement_names = {},
        blind_states = {},
        challenge_names = {},
        collabs = {},
        dictionary = {
            ante_aether_transmit = "Transmit!",
            ante_aether_fused = "Fused!",
            ante_aether_split = "Split!",
            k_swapped_ex = "Swapped!",
        },
        high_scores = {},
        labels = {},
        poker_hand_descriptions = {},
        poker_hands = {},
        quips = {},
        ranks = {},
        suits_plural = {},
        suits_singular = {},
        tutorial = {},
        v_dictionary = {},
        v_text = {},
    },
}
