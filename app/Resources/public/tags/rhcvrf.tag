<rhcvrf>
    <h3 class="text-primary">CVRF List</h3>

    <div>
        <h4>Search Criteria  <small>in Red Hat security DB</small></h4>
        <form id="myform1" class="form-inline" onsubmit={ doRhelGrab } action="#">
            <div class="form-group">
                <label for="iddateafter">Since Date:</label>
                <div id="iddatepicker" class="input-group date" data-provide="datepicker">
                    <input id="dateafter" type="text" class="form-control" name="after" required>
                    <div class="input-group-addon">
                        <span class="glyphicon glyphicon-calendar"></span>
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label for="idseverity">Severity:</label>
                <select id="idseverity" class="form-control" name="severity" required>
                    <option value="critical">Critical</option>
                    <option value="important">Important</option>
                    <option value="moderate">Moderate</option>
                    <option value="low">Low</option>
                </select>
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
                        <!-- <th>Index</th> -->
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Details</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <!-- <th>Index</th> -->
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Details</th>
                    </tr>
                </tfoot>
                <tbody>
                    <tr each="{ value, i in items }">
                        <!-- <td>#{ i }</td> -->
                        <td>{ value.released_on }</td>
                        <td>{ value.RHSA }</td>
                        <td>{ value.severity }</td>
                        <!-- <td>{ value.released_packages }</td> -->
                        <td>
                            <virtual each="{ pkg, j in value.released_packages }">{ pkg }, </virtual>virtual
                        </td>
                        <td><a href="{ convert2Apilink(value.RHSA) }">link</a></td>
                    </tr>
                </tbody>
            </table>

        </div>
        <div if={ items == null || items.length == 0 }>
            <div class="alert alert-info">No CVRF emitted.</div>
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

        doRhelGrab(e) {

            e.preventDefault();

            var queryparams = $('#myform1').serialize();
            // console.log(queryparams);

            this.doApiRequest(queryparams);
        }

        doApiRequest(criteria = null) {

            var apiurl = "/api/rhdb/cvrf";
            if (criteria !== null && 0 !== criteria.length) {
                apiurl += "?" + criteria;
            }

            self.isLoading = true;
            self.update();

            $.getJSON(apiurl, function(results) {
                self.items = results.data;
                console.log(results.data);
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
                $('#cvrftable').DataTable();
            });
        }

        self.on('mount', function(){

            $('#iddatepicker').datepicker({
                autoclose: true,
                clearBtn: true,
                weekStart: 1,
                format: 'yyyy-mm-dd'
            });

            // doApiRequest();
        })

    </script>

</rhcvrf>
