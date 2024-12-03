/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line.h                                    :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: jopedro- <jopedro-@student.42porto.com>    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/11/11 10:46:59 by jopedro-          #+#    #+#             */
/*   Updated: 2024/12/03 10:45:40 by jopedro-         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef GET_NEXT_LINE_H
# define GET_NEXT_LINE_H

# include <stdlib.h>
# include <unistd.h>

# ifndef BUFFER_SIZE
#  define BUFFER_SIZE 1000
# endif

char	*get_next_line(int fd);
char	*ft_find_line(char *text);
char	*ft_strchr(char *s, int c);
int		ft_strlen(char *str);
char	*ft_strjoin(char *s1, char *s2);
char	*ft_leftovers(char *s1);

#endif
