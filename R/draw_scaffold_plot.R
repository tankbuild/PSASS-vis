#' @title Draw scaffold plot
#'
#' @description Draw a scaffold plot from the PoolSex data
#'
#' @param data A PoolSex data structure obtained with the \code{\link{load_data_files}} function.
#'
#' @param scaffold Name of the scaffold to be plotted. The name can be from the dataset (e.g. "NC_0245486.2") or from the
#' 'chromosomes_names' file (e.g. "LG4").
#'
#' @param region A vector specifying the boundaries of the region to be plotted, e.g. c(125000, 250000). If NULL, the entire scaffold
#' will be plotted (default: NULL).
#'
#' @param output.file Path to an output file in PNG format. If NULL, the plot will be drawn in the default graphic device (default: NULL).
#'
#' @param width Width of the output file if specified, in inches (default: 12).
#'
#' @param height Height of the output file if specified, in inches (default: 4 * number of plots).
#'
#' @param dpi Resolution of the output file if specified, in dpi (default: 300).
#'
#' @param tracks Tracks to be plotted. Possible values are "position_fst", "window_fst", "position_snp", "window_snp_males",
#' "window_snp_females", "combined_snp", "coverage_males", "coverage_females", "coverage_ratio"
#' (default: c("window_fst", "combined_snp", "coverage_ratio")).
#'
#' @param point.size Size of the points in the plot (default: 0.1).
#'
#' @param coverage.type Type of coverage to be plotted, either "absolute" or "relative" (default: "absolute").
#'
#' @param min.coverage Minimum coverage to compute coverage ratio.
#' The log of ratio for positions with coverage lower than this value in either sex will be 0 (default: 10).
#'
#' @examples
#'


draw_scaffold_plot <- function(data, scaffold, region = NULL,
                               output.file = NULL, width = 12, height = 4, dpi = 300,
                               tracks = c("window_fst", "window_snp_males", "window_snp_females", "coverage_ratio"),
                               point.size = 0.5, coverage.type = "absolute", min.coverage = 10,
                               major.lines.y = TRUE, major.lines.x = FALSE,
                               fst.window.color = "grey50", males.color = "dodgerblue3", females.color = "firebrick2") {

    # Initialize list of plots
    n_tracks <- length(tracks)
    plots <- rep(list(NULL), n_tracks)

    # Getting scaffold information
    if (scaffold %in% data$names) {
        scaffold_name <- scaffold
        scaffold <- names(data$names[which(data$names == scaffold)])
    } else if (scaffold %in% names(data$names)) {
        scaffold_name <- names(data$names[which(data$names == scaffold)])
    } else {
        stop(paste0(" - Error: scaffold \"", scaffold, "\" does not exist."))
    }

    # Setting region to entire scaffold if region is NULL
    if (is.null(region)) {
        if (scaffold %in% names(data$lengths$lg)) {
            region <- c(0, data$lengths$lg[[scaffold]])
        } else if (scaffold %in% names(data$lengths$unplaced)){
            region <- c(0, data$lengths$unplaced[[scaffold]])
        } else {
            stop(paste0(" - Error: could not find length for scaffold \"", scaffold, "\"."))
        }
    }

    # Draw specified tracks
    for (i in c(1:length(tracks))) {

        bottom.track <- FALSE
        if (i == length(tracks)) bottom.track <- TRUE

        if (tracks[i] == "position_fst") {

            temp <- subset(data$position_fst, data$position_fst$Contig == scaffold &
                           data$position_fst$Position >= region[1] & data$position_fst$Position <= region[2])

            p <- track_scaffold_position_fst(temp, scaffold_name, region,
                                             major.lines.y = major.lines.y, major.lines.x = major.lines.x,
                                             ylim = c(min(temp$Fst), 1), point.size = point.size, bottom.track = bottom.track)
            plots[[i]] <- p

        } else if (tracks[i] == "window_fst") {

            temp <- subset(data$window_fst, data$window_fst$Contig == scaffold &
                           data$window_fst$Position >= region[1] & data$window_fst$Position <= region[2])

            p <- track_scaffold_window_fst(temp, scaffold_name, region,
                                           major.lines.y = major.lines.y, major.lines.x = major.lines.x,
                                           ylim = c(0, max(temp$Fst)), color = fst.window.color, bottom.track = bottom.track)
            plots[[i]] <- p


        } else if (tracks[i] == "position_snp") {

            # TO BE IMPLEMENTED

        } else if (tracks[i] == "window_snp_males") {

            temp <- subset(data$window_snp, data$window_snp$Contig == scaffold &
                           data$window_snp$Position >= region[1] & data$window_snp$Position <= region[2])

            p <- track_scaffold_window_snp(temp, "males", scaffold_name, region,
                                           major.lines.y = major.lines.y, major.lines.x = major.lines.x,
                                           color = males.color, bottom.track = bottom.track)
            plots[[i]] <- p


        } else if (tracks[i] == "window_snp_females") {

            temp <- subset(data$window_snp, data$window_snp$Contig == scaffold &
                        data$window_snp$Position >= region[1] & data$window_snp$Position <= region[2])

            p <- track_scaffold_window_snp(temp, "females", scaffold_name, region,
                                           major.lines.y = major.lines.y, major.lines.x = major.lines.x,
                                           color = females.color, bottom.track = bottom.track)
            plots[[i]] <- p


        } else if (tracks[i] == "window_snp_combined") {

            temp <- subset(data$window_snp, data$window_snp$Contig == scaffold &
                           data$window_snp$Position >= region[1] & data$window_snp$Position <= region[2])

            p <- track_scaffold_window_snp_combined(temp, scaffold_name, region,
                                                    major.lines.y = major.lines.y, major.lines.x = major.lines.x,
                                                    males.color = males.color, females.color = females.color,
                                                    bottom.track = bottom.track)
            plots[[i]] <- p

        } else if (tracks[i] == "window_snp_ratio") {

            temp <- subset(data$window_snp, data$window_snp$Contig == scaffold &
                           data$window_snp$Position >= region[1] & data$window_snp$Position <= region[2])

            p <- track_scaffold_window_snp_ratio(temp, scaffold_name, region,
                                                 major.lines.y = major.lines.y, major.lines.x = major.lines.x,
                                                 males.color = males.color, females.color = females.color,
                                                 bottom.track = bottom.track)
            plots[[i]] <- p

        } else if (tracks[i] == "coverage_males") {

            temp <- subset(data$coverage, data$coverage$Contig == scaffold &
                               data$coverage$Position >= region[1] & data$coverage$Position <= region[2])

            p <- track_scaffold_window_coverage(temp, "males", scaffold_name, region, type = coverage.type,
                                                major.lines.y = major.lines.y, major.lines.x = major.lines.x,
                                                color = males.color, bottom.track = bottom.track)
            plots[[i]] <- p

        } else if (tracks[i] == "coverage_females") {

            temp <- subset(data$coverage, data$coverage$Contig == scaffold &
                           data$coverage$Position >= region[1] & data$coverage$Position <= region[2])

            p <- track_scaffold_window_coverage(temp, "females", scaffold_name, region, type = coverage.type,
                                                major.lines.y = major.lines.y, major.lines.x = major.lines.x,
                                                color = females.color, bottom.track = bottom.track)
            plots[[i]] <- p

        } else if (tracks[i] == "coverage_combined") {

            temp <- subset(data$coverage, data$coverage$Contig == scaffold &
                           data$coverage$Position >= region[1] & data$coverage$Position <= region[2])

            p <- track_scaffold_window_coverage_combined(temp, scaffold_name, region, type = coverage.type,
                                                         major.lines.y = major.lines.y, major.lines.x = major.lines.x,
                                                         males.color = males.color, females.color = females.color,
                                                         bottom.track = bottom.track)
            plots[[i]] <- p

        } else if (tracks[i] == "coverage_ratio") {

            temp <- subset(data$coverage, data$coverage$Contig == scaffold &
                               data$coverage$Position >= region[1] & data$coverage$Position <= region[2])

            p <- track_scaffold_window_coverage_ratio(temp, scaffold_name, region, type = coverage.type, min.coverage = min.coverage,
                                                      major.lines.y = major.lines.y, major.lines.x = major.lines.x,
                                                      males.color = males.color, females.color = females.color,
                                                      bottom.track = bottom.track)
            plots[[i]] <- p

        } else {

            print(paste0("Warning: unknown track type \"", tracks[i], "\" ..."))

        }
    }

    combined <- cowplot::plot_grid(plotlist = plots, ncol = 1, align = "v")

    if (!is.null(output.file)) {

        cowplot::ggsave(output.file, plot = combined, width = width, height = height * n_tracks, dpi = dpi)

    } else {

        print(combined)

    }
}