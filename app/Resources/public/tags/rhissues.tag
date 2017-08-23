<issues>
    <h3 class="text-primary">Issues List</h3>

    <div>
        <h4>Search Criteria</h4>
        <form id="myform1" class="form-inline" onsubmit={ doSubmit } action="#">
            <div class="form-group">
                <label for="iddateafter">Since Date:</label>
                <div id="iddatepicker" class="input-group date" data-provide="datepicker">
                    <input id="dateafter" type="text" class="form-control" name="after">
                    <div class="input-group-addon">
                        <span class="glyphicon glyphicon-calendar"></span>
                    </div>
                </div>
            </div>
            <button type="submit" class="btn btn-success">Apply</button>
        </form>
    </div>

    <hr>

    <div if={ isLoading } class='loader center-block'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:36px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >
        <div if={ items.length }>

            <table id="cvrftable" class="table table-striped table-bordered" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th>Issue Tag</th>
                        <th>Accepted Errata</th>
                    </tr>
                </thead>
<!--                 <tfoot>
                    <tr>
                        <th>Issue ID</th>
                        <th>Errata</th>
                    </tr>
                </tfoot> -->
                <tbody>
                    <tr each="{ value, i in items }">
                        <td>{ value.tag }</td>
                        <td>
                            <virtual each="{ err, j in value.errata }">{ err }, </virtual>
                        </td>
                        <!-- <td><a href="{ convert2Apilink(value.RHSA) }">link</a></td> -->
                    </tr>
                </tbody>
            </table>

        </div>
        <div if={ items == null || items.length == 0 }>
            <div class="alert alert-info">No Issue ID found.</div>
        </div>
    </div>

    <script>

        this.items = [];
        this.isLoading = false;
        this.error = null;

        var self = this

        convert2Apilink(rhsa) {

            return '/gui/erratadetails/cvrf/' + rhsa;
        }

        doSubmit(e) {

            e.preventDefault();

            var queryparams = $('#myform1').serialize();
            // console.log(queryparams);

            this.doApiRequest(queryparams);
        }

        doApiGetRequest(criteria = null) {

            var apiurl = "/api/triaged/assigned";
            // if (criteria !== null && 0 !== criteria.length) {
            //     apiurl += "?" + criteria;
            // }

            self.isLoading = true;
            self.error = false;
            self.update();

            $.getJSON(apiurl, function(results) {
                self.items = results.data;
                console.log(self.items);
            })
            .done(function() {
            // alert( "second success" );
            })
            .fail(function() {
                // alert( "error" );
                self.error = "Failed to retrieve data from server!";
            })
            .always(function() {
                // alert( "finished" );
                self.isLoading = false;
                self.update()
                //$('#cvrftable').DataTable();
            });
        }

        self.on('mount', function(){

            $('#iddatepicker').datepicker({
                autoclose: true,
                clearBtn: true,
                weekStart: 1,
                format: 'yyyy-mm-dd'
            });

            self.doApiGetRequest();
        })

    </script>

</issues>
