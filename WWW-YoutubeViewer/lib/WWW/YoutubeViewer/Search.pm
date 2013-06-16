package WWW::YoutubeViewer::Search;

use strict;

=head1 NAME

WWW::YoutubeViewer::Search - Search functions for Youtube API v3

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

    use WWW::YoutubeViewer;
    my $obj = WWW::YoutubeViewer->new(%opts);
    $obj->search_videos(@keywords);

=head1 SUBROUTINES/METHODS

=cut

sub _make_search_url {
    my ($self, %opts) = @_;

    return $self->_make_feed_url(
        'search',

        topicId    => $self->get_topicId,
        regionCode => $self->get_regionCode,

        #maxResults      => $self->get_maxResults,
        order           => $self->get_order,
        publishedAfter  => $self->get_publishedAfter,
        publishedBefore => $self->get_publishedBefore,

        (
         $opts{type} =~ /\bvideo\b/
         ? (
            videoCaption    => $self->get_videoCaption,
            videoCategoryId => $self->get_videoCategoryId,
            videoDefinition => $self->get_videoDefinition,
            videoDimension  => $self->get_videoDimension,
            videoDuration   => $self->get_videoDuration,
            videoEmbeddable => $self->get_videoEmbeddable,
            videoLicense    => $self->get_videoLicense,
            videoSyndicated => $self->get_videoSyndicated,
           )
         : ()
        ),

        %opts,
                                );

}

sub _search {
    my ($self, $type, $keywords, $args) = @_;

    $keywords //= [];
    ref $keywords ne 'ARRAY' && ($keywords = [$keywords]);

    my $url = $self->_make_search_url(
                                      type => $type,
                                      q    => $self->escape_string("@{$keywords}"),
                                      (ref $args eq 'HASH' ? %{$args} : ()),
                                     );

    return $self->_get_results($url);
}

=head2 search_videos($keywords;\%args)

Search and return the found video results.

=cut

sub search_videos {
    my $self = shift;
    return $self->_search('video', @_);
}

=head2 search_playlists($keywords;\%args)

Search and return the found playlists.

=cut

sub search_playlists {
    my $self = shift;
    return $self->_search('playlist', @_);
}

=head2 search_channels($keywords;\%args)

Search and return the found channels.

=cut

sub search_channels {
    my $self = shift;
    return $self->_search('channel', @_);
}

=head2 search_all($keywords;\%args)

Search and return the results.

=cut

sub search_all {
    my $self = shift;
    return $self->_search('video,channel,playlist', @_);
}

=head2 related_to_videoID($id)

Retrieves a list of videos that are related to the video
that the parameter value identifies. The parameter value must
be set to a YouTube video ID.

=cut

sub related_to_videoID {
    my ($self, $id) = @_;
    return $self->_search('video', [], {relatedToVideoId => $id});
}

=head1 AUTHOR

Suteu "Trizen" Daniel, C<< <trizenx at gmail.com> >>


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::YoutubeViewer::Search


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Suteu "Trizen" Daniel.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1;    # End of WWW::YoutubeViewer::Search
