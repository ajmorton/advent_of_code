import read_as

def recursive_combat(player_cards, crab_cards, history, part_2):
    while len(player_cards) > 0 and len(crab_cards) > 0:
        if (tuple(player_cards), tuple(crab_cards)) in history:
            return True, player_cards
        else:
            history[(tuple(player_cards), tuple(crab_cards))] = 1

        player_card, player_cards = player_cards[0], player_cards[1:]
        crab_card, crab_cards = crab_cards[0], crab_cards[1:]

        if part_2 and player_card <= len(player_cards) and crab_card <= len(crab_cards):
            player_wins, _ = recursive_combat(player_cards[:player_card], crab_cards[:crab_card], {}, part_2)
            if player_wins:
                player_cards.extend([player_card, crab_card])
            else:
                crab_cards.extend([crab_card, player_card])
        else:
            if player_card > crab_card:
                player_cards.extend([player_card, crab_card])
            else:
                crab_cards.extend([crab_card, player_card])

    return (True, player_cards) if len(player_cards) > 0 else (False, crab_cards)

def run() -> (int, int):
    groups = read_as.groups("input/22.txt")
    player_cards = [int(n) for n in groups[0][1:]]
    crab_cards = [int(n) for n in groups[1][1:]]

    _, winner_hand_p1 = recursive_combat(player_cards, crab_cards, {}, False)
    _, winner_hand_p2 = recursive_combat(player_cards, crab_cards, {}, True)

    score_p1 = sum([(i+1) * n for (i, n) in enumerate(winner_hand_p1[::-1])])
    score_p2 = sum([(i+1) * n for (i, n) in enumerate(winner_hand_p2[::-1])])
    return (score_p1, score_p2)

if __name__ == "__main__":
    print(run())