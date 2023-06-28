from typing import Tuple


class SpDiff:
    # Splinestein diffing algorithm.

    def longest_string(self, a: str, b: str) -> Tuple[str, str]:
        # Commutative; makes a the longest string.
        if len(a) < len(b):
            a, b = b, a
        return a, b

    def longest_number(self, a: int, b: int) -> Tuple[int, int]:
        # Commutative; makes a the longest number.
        if a < b:
            a, b = b, a
        return a, b

    def longest_common_match(self, a: str, b: str) -> Tuple[str, int]:
        matches = []
        all_match_count = 0

        # Iterate over the characters in b for each character in a.
        for i in range(len(a)):
            for j in range(len(b)):
                # Create an empty table to store the current match and iterate over the characters, starting at index i.
                current_match = []
                for k in range(i, len(a)):
                    # Check if the character at index k in a is the same as the character at index j in b.
                    if j < len(b) and a[k] == b[j]:
                        # If the characters are the same, add the character to the current match table.
                        current_match.append(a[k])
                        # Increment j to compare the next character in b.
                        j += 1
                    else:
                        # If the characters are different, break the inner loop.
                        break

                # Skip empty matches, only store those we found.
                if len("".join(current_match)) > 0:
                    all_match_count += 1

                # Update the longest match if the current one is longer.
                if len(current_match) > len(matches):
                    matches = current_match

        # Return both the longest match and the count.
        return "".join(matches), all_match_count

    def perfect_common_match_calc(self, a: str) -> int:
        """
        In an ideal scenario, how many common matches would be made?
        If both strings are "aaabb" it's (equation):
        (how many a's * how many a's) + unique character (how many b's * how many b's) + ... = 13
        """
        counts = {}

        for character in a:
            if character in counts:
                counts[character] += 1
            else:
                counts[character] = 1

        total_matches = 0

        for count in counts.values():
            total_matches += count * count

        return total_matches

    def compare(self, a: str, b: str) -> Tuple[float, str]:
        # Ensure that A is always the longest to be compared against.
        a, b = self.longest_string(a, b)

        # In an ideal scenario, how many matches could in theory be made?
        perfect_match_count = self.perfect_common_match_calc(a)

        # Find the longest match.
        longest_match, all_match_count = self.longest_common_match(a, b)

        # How big of a portion does the largest match take out of the sentence?
        matches_length_compared = (len(longest_match) / len(a)) * 100

        # How many matches could've been made in an ideal perfect scenario?
        match_count_similarity = (all_match_count / perfect_match_count) * 100

        # How long both a and b are compared to each other?
        string_length_similarity = (len(b) / len(a)) * 100

        # Average out most important percentages, match length portion and count similarity for best result.
        average_count_match_ratio = (
            matches_length_compared + match_count_similarity
        ) / 2

        # We want to calculate how much we should change the ratio.
        a_calc, b_calc = self.longest_number(
            average_count_match_ratio, string_length_similarity
        )

        # Main ratio calculation.
        ratio = average_count_match_ratio * (((b_calc / a_calc) * 100) / 100)

        return ratio, longest_match
