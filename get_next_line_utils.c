/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line_utils.c                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jopedro- <jopedro-@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/11/11 10:49:06 by jopedro-          #+#    #+#             */
/*   Updated: 2024/11/11 10:56:43 by jopedro-         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "get_next_line.h"

char	*ft_leftovers(char *text)
{
	int		i;
	int		j;
	char	*left;

	i = 0;
	while (text[i] && text[i] != '\n')
		++i;
	if (!text[i])
		return (free(text), NULL);
	left = (char *)malloc(sizeof(char) * (ft_strlen(text) - i + 1));
	if (!left)
		return (free(left), NULL);
	i++;
	j = 0;
	while (text[i] && text[i] != '\n')
		left[j++] = text[i++];
	left[j] = '\0';
	free(text);
	return (left);
}

char	*ft_strjoin(char *s1, char *s2)
{
	size_t	i;
	size_t	j;
	char	*str;

	if (!s1)
	{
		s1 = (char *)malloc(1 * sizeof(char));
		s1[0] = '\0';
	}
	if (!s1 || !s2)
		return (NULL);
	str = (char *)malloc(sizeof(char) * (ft_strlen(s1) + ft_strlen(s2) + 1));
	if (!str)
		return (NULL);
	i = -1;
	j = 0;
	if (s1)
		while (s1[++i])
			str[i] = s1[i];
	while (s2[j])
		str[i++] = s2[j++];
	str[i] = '\0';
	free(s1);
	return (str);
}

int	ft_strlen(char *str)
{
	int	i;

	if (!str)
		return (0);
	i = 0;
	while (str[i])
		i++;
	return (i);
}

char	*ft_strchr(char *s, int c)
{
	if (!s)
		return (0);
	if (c == '\0')
		return ((char *)&s[ft_strlen(s)]);
	while (*s != (unsigned char)c)
		if (!*s++)
			return (0);
	return ((char *)s);
}
