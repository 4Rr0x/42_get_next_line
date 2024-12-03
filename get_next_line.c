/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line.c                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jopedro- <jopedro-@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/11/11 10:26:50 by jopedro-          #+#    #+#             */
/*   Updated: 2024/11/11 11:16:38 by jopedro-         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "get_next_line.h"

char	*ft_read_file(int fd, char *text)
{
	char	*buff;
	int		bytes_read;

	buff = malloc(sizeof(char) * (BUFFER_SIZE + 1));
	if (!buff)
		return (NULL);
	bytes_read = 1;
	while (bytes_read != 0 && !ft_strchr(text, '\n'))
	{
		bytes_read = read(fd, buff, BUFFER_SIZE);
		if (bytes_read == -1)
			return (free(buff), NULL);
		if (bytes_read == 0)
			return (free(buff), free(text), NULL);
		buff[bytes_read] = '\0';
		text = ft_strjoin(text, buff);
	}
	free(buff);
	return (text);
}

char	*ft_find_line(char	*text)
{
	int		i;
	int		j;
	char	*line;

	if (!text)
		return (NULL);
	i = 0;
	while (text[i] && text[i] != '\n')
	{
		i++;
	}
	line = (char *)malloc(sizeof(char) * (i + 2));
	if (!line)
		return (NULL);
	j = 0;
	while (text[i] && j < i)
	{
		line[j] = text[j];
		j++;
	}
	line[j++] = '\n';
	line[j] = '\0';
	return (line);
}

char	*get_next_line(int fd)
{
	char		*line;
	static char	*text;

	if (fd < 0 || BUFFER_SIZE <= 0)
		return (0);
	text = ft_read_file(fd, text);
	if (!text)
		return (NULL);
	line = ft_find_line(text);
	text = ft_leftovers(text);
	return (line);
}
